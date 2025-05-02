from portkey_ai import Portkey
import os

portkey = Portkey(
    base_url="https://ai-gateway.apps.cloud.rt.nyu.edu/v1/",
    api_key=os.getenv("PORTKEY_API_KEY"),
    virtual_key=os.getenv("PORTKEY_VIRTUAL_KEY"),
)

completion = portkey.chat.completions.create(
    model=os.getenv("LLM_MODEL"),
    messages=[
        {"role": "system", "content": "You are not a helpful assistant"},
        {
            "role": "user",
            "content": "Complete the following sentence:The sun is shining and the sky is",
        },
    ],
)

print(completion)
