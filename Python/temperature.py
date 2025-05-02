import asyncio
import argparse
import os
from portkey_ai import AsyncPortkey

portkey = AsyncPortkey(
    base_url="https://ai-gateway.apps.cloud.rt.nyu.edu/v1/",
    api_key=os.getenv("PORTKEY_API_KEY"),
    virtual_key=os.getenv("PORTKEY_VIRTUAL_KEY"),
)


async def get_completion(input_temp: float):
    completion = await portkey.chat.completions.create(
        model=os.getenv("LLM_MODEL"),
        temperature=input_temp,
        messages=[
            {"role": "system", "content": "You are not a helpful assistant"},
            {
                "role": "user",
                "content": """Complete the following sentence:
                The sun is shining and the sky is""",
            },
        ],
    )
    return completion


async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("temperature", help="temperature", type=float, default=2.0)
    parser.add_argument(
        "n", help="number of completions to generate", type=int, default=10
    )
    args = parser.parse_args()

    try:
        tasks = []
        async with asyncio.TaskGroup() as tg:
            for _ in range(args.n):
                tasks.append(tg.create_task(get_completion(args.temperature)))
        for idx in range(args.n):
            response = tasks[idx].result().choices[0]["message"]["content"]
            print(f"response number {idx} is {response}")
    except Exception as e:
        print(f"Error: {e}")


asyncio.run(main())
