local env = require("env")
local jwt = require("resty.jwt")

return function(payload, expire_in_minutes)
	local jwt_key = env.JWT_SECRET_KEY
	local header = { typ = "JWT", alg = "HS512" }
	payload.exp = os.time() + (60 * expire_in_minutes)

	local signed_token = jwt:sign(jwt_key, { header = header, payload = payload })
	return signed_token
end
