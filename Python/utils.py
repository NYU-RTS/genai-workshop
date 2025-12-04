from attrs import define


type JSONVal = None | bool | str | float | int | JSONArray | JSONObject
type JSONArray = list[JSONVal]
type JSONObject = dict[str, JSONVal]


@define
class client_config:
    api_key: str
    llm_model: str
    gateway_url: str = "https://ai-gateway.apps.cloud.rt.nyu.edu/v1/"
