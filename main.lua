local amazonAds = require "plugin.amazonAds"
local widget = require( "widget" )
local json = require "json"


local function Callback(event)
	print("Callback: "..json.encode(event))
	if event.name == "license" then
		print("event.type: "..event.type, "event.status: "..event.status)
	elseif event.name == "collapsed" then
		print("Ad collapsed")
	elseif event.name == "failed" then
		print("Ad failed to load. isError:"..tostring(event.isError), event.response)
	elseif event.name == "loaded" then
		print("Ad loaded", event.response)
	elseif event.name == "expanded" then
		print("Ad expanded")
	elseif event.name == "dismissed" then
		print("Ad dismissed")
	end
end
amazonAds.init({appKey = "sample-app-v1_pub-2", testMode = true, licenseKey = "LicenseKey"}, Callback)



local function pressShowBannerButton(event)
	amazonAds.show({x=0, y=0, timeout = 20, size = "SIZE_300x250"}) --Sizes(optional): "SIZE_1024x50", "SIZE_300x250", "SIZE_300x50", "SIZE_320x50", "SIZE_600x90", "SIZE_728x90"; x=0, y=0 for default (top) positioning. top left coordinates of banners
end


local showBannerButton = widget.newButton
{
	width = 198,
	height = 59,
	label = "Show Banner",
	onRelease = pressShowBannerButton,
}
showBannerButton.x = display.contentWidth/2
showBannerButton.y = display.contentHeight/6

local function pressShowInterstitialButton(event)
	amazonAds.show({size = "interstitial"}) 
end


local showInterstitialButton = widget.newButton
{
	width = 198,
	height = 59,
	label = "Show Interstitial",
	onRelease = pressShowInterstitialButton,
}
showInterstitialButton.x = display.contentWidth/2
showInterstitialButton.y = display.contentHeight/6*2

local function pressHideButton(event)
	amazonAds.hide()
end


local hideButton = widget.newButton
{
	width = 198,
	height = 59,
	label = "Hide",
	onRelease = pressHideButton,
}
hideButton.x = display.contentWidth/2
hideButton.y = display.contentHeight/6*3

local function pressHideBannerButton(event)
	amazonAds.hide("banner")
end


local hideBannerButton = widget.newButton
{
	width = 198,
	height = 59,
	label = "Hide Banner",
	onRelease = pressHideBannerButton,
}
hideBannerButton.x = display.contentWidth/2
hideBannerButton.y = display.contentHeight/6*4

local function pressHideInterstitialButton(event)
	amazonAds.hide("interstitial")
end


local hideInterstitialButton = widget.newButton
{
	width = 198,
	height = 59,
	label = "Hide Interstitial",
	onRelease = pressHideInterstitialButton,
}
hideInterstitialButton.x = display.contentWidth/2
hideInterstitialButton.y = display.contentHeight/6*5

