local PANEL = {}
local PlayerVoicePanels = {}

function PANEL:Init()
	self.LabelName = vgui.Create( 'DLabel', self )
	self.LabelName:SetFont( 'GModNotify' )
	self.LabelName:Dock( FILL )
	self.LabelName:DockMargin( 4, 0, 0, 0 )
	self.LabelName:SetTextColor( DMColor.label_text )

	self.Avatar = vgui.Create( 'dm_avatar', self )
	self.Avatar:Dock( LEFT )
	self.Avatar:SetWide( 32 )

	self:SetSize( 250, 40 )
	self:DockPadding( 4, 4, 4, 4 )
end

function PANEL:Setup( ply )
	self.ply = ply

	self.LabelName:SetText( ply:GetNick() )

	self.Avatar:SetPlayer( ply )

	self:InvalidateLayout()
end

PANEL.lastw = 0
PANEL.lastName = ''

function PANEL:Paint( w, h )
	if ( not IsValid( self.ply ) ) then
		return
	end

	local cw = w

	w = self.lastw

	draw.RoundedBox( 6, 0, 0, w, h, DMColor.frame_background )

	if ( self.lastw != cw ) then
		local nick = self.ply:GetNick()

		surface.SetFont( 'GModNotify' )

		local w2, h2 = surface.GetTextSize( nick )

		w2 = w2 + 32 + 13

		self:SetSize( w2, h )
		self.lastw = w2

		if ( self.lastName != nick ) then
			self.LabelName:SetText( nick )

			self.lastName = nick
		end
	end
end

function PANEL:Think( )
	if ( self.fadeAnim ) then
		self.fadeAnim:Run()
	end
end

function PANEL:FadeOut( anim, delta, data )
	if ( anim.Finished ) then
		if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil

			return
		end

		return
	end

	self:SetAlpha( 255 - ( 255 * delta ) )
end

derma.DefineControl( 'VoiceNotify2', '', PANEL, 'DPanel' )

function GM:PlayerStartVoice( ply )
	if ( not IsValid( g_VoicePanelList ) ) then
		return
	end

	GAMEMODE:PlayerEndVoice( ply )

	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then
		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			PlayerVoicePanels[ ply ].fadeAnim:Stop()
			PlayerVoicePanels[ ply ].fadeAnim = nil
		end

		PlayerVoicePanels[ ply ]:SetAlpha( 255 )

		return
	end

	if ( not IsValid( ply ) ) then
		return
	end

	local pnl = g_VoicePanelList:Add( 'VoiceNotify2' )
	pnl:Setup( ply )

	PlayerVoicePanels[ ply ] = pnl
end

local function VoiceClean()
	for k, v in pairs( PlayerVoicePanels ) do
		if ( not IsValid( k ) ) then
			GAMEMODE:PlayerEndVoice( k )
		end
	end
end

timer.Create( 'VoiceClean', 10, 0, VoiceClean )

function GM:PlayerEndVoice( ply )
	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then
		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			return
		end

		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( 'FadeOut', PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 0.5 )
	end
end

local function CreateVoiceVGUI()
	g_VoicePanelList = vgui.Create( 'DPanel' )
	g_VoicePanelList:ParentToHUD()
	g_VoicePanelList:SetPos( 20, 20 )
	g_VoicePanelList:SetSize( 250, ScrH() - 40 )
	g_VoicePanelList:SetDrawBackground( false )
end

if ( IsValid( g_VoicePanelList ) ) then
	g_VoicePanelList:Remove()

	CreateVoiceVGUI()
end

hook.Add( 'InitPostEntity', 'CreateVoiceVGUI', CreateVoiceVGUI )
