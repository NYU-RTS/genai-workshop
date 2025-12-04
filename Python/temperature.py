from portkey_ai import AsyncPortkey
import asyncio
import argparse
import os
import utils


async def get_completion(client: AsyncPortkey, llm_model: str, temperature: float):
    completion = await client.chat.completions.create(
        model=llm_model,
        temperature=temperature,
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


async def get_responses(client: AsyncPortkey, llm_model: str, temperature: float, num_responses: int):
    try:
        tasks = []
        async with asyncio.TaskGroup() as tg:
            for _ in range(num_responses):
                tasks.append(tg.create_task(get_completion(client, llm_model, temperature)))
        for idx in range(num_responses):
            response = tasks[idx].result().choices[0]["message"]["content"]
            print(f"response number {idx} is {response}")
    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    portkey_client_config = utils.client_config(
        api_key=os.environ["PORTKEY_API_KEY"],
        llm_model=os.environ["LLM_MODEL"],
    )

    client = AsyncPortkey(
        base_url=portkey_client_config.gateway_url,
        api_key=portkey_client_config.api_key,
    )
    parser = argparse.ArgumentParser()
    parser.add_argument("temperature", help="temperature", type=float, default=2.0)
    parser.add_argument("n", help="number of completions to generate", type=int, default=10)
    args = parser.parse_args()

    asyncio.run(get_responses(client, portkey_client_config.llm_model, args.temperature, args.n))
