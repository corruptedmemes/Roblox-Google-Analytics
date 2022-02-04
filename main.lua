-->> Services
local HttpService = game:GetService("HttpService")

-->> Module
local Analytics = {}

-->> Variables
local Id = "ID"
local GoogleUserId = {HttpService:GenerateGUID(), os.time()}

-->> External Functions
function Analytics.ReportEvent(Category, Action, Label, Value)
	local NumberValue = tonumber(Value)
	if NumberValue == nil or NumberValue ~= math.floor(NumberValue) then
		warn("[Analytics]: NumberValue was not an integer, Event String: ", "GA EVENT: " .."Category: [" .. tostring(Category) .. "] " .. "Action: [" .. tostring(Action) .. "] " .."Label: [" .. tostring(Label) .. "] " .."Value: [" .. tostring(Value) .. "]")
		return
	end
	Value = NumberValue
	if game:FindFirstChild("NetworkServer") ~= nil then
		if Id == nil then
			warn("[Analytics]: Couldn't report event because there is no id")
			return
		end		

		if os.time() - GoogleUserId[2] > 7200 then
			GoogleUserId[1] = game:GetService("HttpService"):GenerateGUID()
			GoogleUserId[2] = os.time()
		end

		HttpService:PostAsync(
			"http://www.google-analytics.com/collect",
			"v=1&t=event&sc=start" ..
				"&tid=" .. Id .. 
				"&cid=" .. GoogleUserId[1] ..
				"&ec=" .. HttpService:UrlEncode(Category) ..
				"&ea=" .. HttpService:UrlEncode(Action) .. 
				"&el=" .. HttpService:UrlEncode(Label) ..
				"&ev=" .. HttpService:UrlEncode(Value),
			Enum.HttpContentType.ApplicationUrlEncoded)
	end
end

return Analytics
