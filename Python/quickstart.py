from portkey_ai import Portkey
import os
import utils


def get_chat_completion(config: utils.client_config) -> utils.JSONVal:
    portkey = Portkey(
        base_url=config.gateway_url,
        api_key=config.api_key,
        virtual_key=config.virtual_key,
    )
    completion = portkey.chat.completions.create(
        model=config.llm_model,
        messages=[
            {"role": "system", "content": "You are not a helpful assistant"},
            {
                "role": "user",
                "content": "Complete the following sentence:The sun is shining and the sky is",
            },
        ],
    )
    return completion


if __name__ == "__main__":
    portkey_client_config = utils.client_config(
        api_key=os.environ["PORTKEY_API_KEY"],
        virtual_key=os.environ["PORTKEY_VIRTUAL_KEY"],
        llm_model=os.environ["LLM_MODEL"],
    )

    print(get_chat_completion(portkey_client_config))
