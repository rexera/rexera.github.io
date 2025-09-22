---
title: "Implementation of LLM-Based Multi-Agent Systems: A Toy Survey"
date: 2025-04-13
categories: [Technical, MAS]
---

> By no means is the notion of "Agent", which has long been discussed in AI research since early works like *Society of Minds* by Marvin Minsky, novel or peculiar to present days, let alone when extended to multi-agent systems (MAS). Its implementation based on LLMs, however, constitutes the genuine issue posed ahead of researchers nowadays.

## Principles

A commonly neglected factor (well, at least for me in the first place) when developing a LLM-based MAS is the starking fact that LLMs are **NOT** generically built (or in this case, trained) for multi-agent communications. So in this section, we start with a quick overview of general principles of LLM pre-training (in broad sense) before diving into the principles of MAS.

### LLM Pre-training Principles

#### Autoregressive Language Modeling (Pre-training)
LLMs are fundamentally trained on **autoregressive** language modeling objectives, where the model learns to predict the next token given all previous tokens in a sequence. This approach enables the model to capture complex linguistic patterns, contextual relationships, and semantic structures within text.


```python
from huggingface_hub import InferenceClient

client = InferenceClient(
	provider="hf-inference",
	api_key="hf_xxxxxxxxxxxxxxxxxxxxxxxx"
)
result = client.text_generation(
	model="openai-community/gpt2",
	inputs="Legal Intelligence is",
	provider="hf-inference",
)
print(result)
```
The result would be:
```
[Legal Intelligence is] a non-profit organization that provides legal advice to law enforcement agencies.

The organization is a
```
which is obviously *making sense autoregressively* but gibberish.

#### Instruction Tuning
To this end, after pre-training, models are supposed to undergo instruction tuning to align with user intent:
- Models are fine-tuned on datasets containing instruction-response pairs
- This process enhances the model's ability to interpret and follow specific directives
- The instruction format creates a structured interface for human-AI interaction

#### Instruction Tuning Example

Instruction tuning involves training models on specific instruction-response pairs to improve their ability to follow directions. Here's a concrete example:

```json
[
    {
        "role": "user",
        "content": "What is legal intelligence and how is it applied in the legal field?"
    },
    {
        "role": "assistant",
        "content": "Legal intelligence refers to the application of artificial intelligence and data analytics technologies to legal processes and services. It involves using advanced computational methods to analyze legal documents, predict case outcomes, and automate routine legal tasks. In practice, legal intelligence systems can help lawyers research precedents more efficiently, identify relevant statutes, extract key information from contracts, and even predict litigation outcomes based on historical data. This technology is transforming how legal professionals work by reducing time spent on repetitive tasks and providing deeper insights into complex legal matters."
    }
]
```

This example demonstrates how instruction tuning helps models generate responses that are:
- Appropriately **understandable** for human
- Directly addressing the **instruction's intent**
- Structured in a helpful, informative manner


#### Reinforcement Learning from Human Feedback (RLHF)
RLHF further refines model outputs through a multi-stage process:
- Human evaluators rank model responses based on quality, helpfulness, and safety
- A reward model is trained on these human preferences
- The language model is optimized using reinforcement learning techniques (typically PPO) to maximize the reward function
- This process mitigates harmful outputs while enhancing alignment with human values

```json
{
    "prompt": "What is legal intelligence and how is it applied in the legal field?",
    "model_responses": [
        {
            "response": "Legal intelligence is a non-profit organization that provides legal advice to law enforcement agencies. The organization helps police departments with their legal needs.",
            "human_ratings": {
                "quality": 2,
                "helpfulness": 1,
                "safety": 3,
            }
        },
        {
            "response": "Legal intelligence refers to the application of artificial intelligence and data analytics technologies to legal processes and services. It involves using advanced computational methods to analyze legal documents, predict case outcomes, and automate routine legal tasks. In practice, legal intelligence systems can help lawyers research precedents more efficiently, identify relevant statutes, extract key information from contracts, and even predict litigation outcomes based on historical data. This technology is transforming how legal professionals work by reducing time spent on repetitive tasks and providing deeper insights into complex legal matters.",
            "human_ratings": {
                "quality": 9,
                "helpfulness": 9,
                "safety": 9,
            }
        },
        {
            "response": "Legal intelligence is when computers help lawyers do their job. It's like having a robot assistant that can read documents and give advice. Some people worry it might replace lawyers, but it's really just a tool to make their work easier.",
            "human_ratings": {
                "quality": 5,
                "helpfulness": 4,
                "safety": 6,
            }
        }
    ],
    "reward_model_training": {
        "features": [
            "technical_accuracy",
            "professional_tone",
            "comprehensiveness",
            "practical_applications",
            "clarity",
            "safety_considerations"
        ],
        "weights": [0.25, 0.15, 0.2, 0.2, 0.1, 0.1],
        "optimization_algorithm": "PPO",
        "learning_rate": 0.0001
    },
    "final_optimized_response": "Legal intelligence refers to the application of artificial intelligence and data analytics technologies to legal processes and services. It involves using advanced computational methods to analyze legal documents, predict case outcomes, and automate routine legal tasks. In practice, legal intelligence systems can help lawyers research precedents more efficiently, identify relevant statutes, extract key information from contracts, and even predict litigation outcomes based on historical data. This technology is transforming how legal professionals work by reducing time spent on repetitive tasks and providing deeper insights into complex legal matters."
}
```


These training paradigms create foundation models that, while powerful for individual tasks, are **NOT** inherently designed for multi-agent collaboration (the evidence for my statement can be found later in [this part](#on-conversation-history)). The gap between single-agent capabilities and effective multi-agent coordination represents a significant challenge in LLM-based MAS development.

> **Potential Research Topic 1:** Foundation Models for Multi-Agent Settings, i.e., how to train a model that is inherently designed for multi-agent collaboration? What kind of data do we need? Training methods? 

### Response Generation

The implementation of LLM-based multi-agent systems primarily involves **response generation** and **communication**. 

Communication, **in essence**, is the process of structuring previous responses as context/messages for generating new responses. Therefore, the key aspect to examine is the mechanism behind response generation.

- Online Models: Utilize APIs such as the `openai`-like SDK (e.g., Chat Completion, Function Calling, Embedding, ...) or other framworks that re-use standard OpenAI-like API response.
- Local Models: `transformers`, vLLM, ollama, etc.

Demo for vLLM:
```python
from vllm import LLM, SamplingParams
prompts = [
    "Hello, my name is",
    "The president of the United States is",
    "The capital of France is",
    "The future of AI is",
]
sampling_params = SamplingParams(temperature=0.8, top_p=0.95)
llm = LLM(model="facebook/opt-125m")
outputs = llm.generate(prompts, sampling_params)

for output in outputs:
    prompt = output.prompt
    generated_text = output.outputs[0].text
    print(f"Prompt: {prompt!r}, Generated text: {generated_text!r}")
```

Demo for vLLM, `openai`-like API:
```bash
vllm serve Qwen/Qwen2.5-1.5B-Instruct
```
```python
from openai import OpenAI
# Set OpenAI's API key and API base to use vLLM's API server.
openai_api_key = "EMPTY"
openai_api_base = "http://localhost:8000/v1"

client = OpenAI(
    api_key=openai_api_key,
    base_url=openai_api_base,
)

chat_response = client.chat.completions.create(
    model="Qwen/Qwen2.5-1.5B-Instruct",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Tell me what legal intelligence is."},
    ]
)
print("Chat response:", chat_response)
```

## Categories of MAS

1. Interaction Models
- Cooperative Agents: Agents work together towards a common goal.
- Competitive Agents: Agents have conflicting objectives and compete against each other.
- Team-Based Competition: Teams of agents compete against each other.

<img width="943" alt="image" src="https://github.com/user-attachments/assets/712f8605-8eef-46c5-b58e-e74cc46bbbd1" />


2. Functional Purposes
- Task-Oriented Systems: Designed to complete specific tasks.
  - Examples: ChatDev (AI-driven software development), Agent Hospital (medical consultation), AI translation companies, ChatEval.
- Scenario Simulation Systems: Focused on role-playing and interactive storytelling.
  - Examples: Stanford Smallville (social simulation), Werewolf Game (deception and reasoning), Court Trial Simulations.

3. Implementation Strategies

    a. Interaction Mechanisms
    - Rule-Based Systems: Agents follow predefined rules to interact.
    - Role-Playing Systems: Agents assume specific personas or roles.
    - Environment-Interaction Systems (Model-Based): Agents interact dynamically with their surroundings and adapt accordingly.
  
   <img width="943" alt="image" src="https://github.com/user-attachments/assets/3b25b182-24e5-4f84-b6ca-a23796bf3fc8" />


    b. Agent Topology
    - Centralized Topology: One agent dominates the process.
    - Decentralized Topology: No single controlling entity; agents coordinate autonomously.
    - Hierarchical Topology: Some agents manage or supervise others, forming structured layers.

    c. Management Strategies
    - Static Management: Agent behaviors and roles are predefined and fixed.
    - Dynamic Planning: Agent actions and roles adapt over time based on changing goals or contexts. (Internet-of-Agent)

This classification provides a structured understanding of how LLM-based multi-agent systems are categorized and implemented across different applications.

> Chen, S., Liu, Y., Han, W., Zhang, W., & Liu, T. (2025). A Survey on LLM-based Multi-Agent System: Recent Advances and New Frontiers in Application (No. arXiv:2412.17481). arXiv. https://doi.org/10.48550/arXiv.2412.17481


## Common Frameworks for MAS

- AutoGen (Microsoft)
- LangGraph (LangChain)
- OpenAI Swarm (OpenAI)
- Magentic-One (Microsoft)
- AgentVerse (THUNLP)
- AgentScope (Ali)
- from scratch: practicable, with harder abstract class and attribute management

## Efficient MAS

Optimizing MAS performance involves reducing computational overhead by 1) **minimizing prompt tokens** and 2) **inter-agent communication costs**.

### 1. Prompt Compression (Caching)

Just as at the model level there's KV Cache mechanism for repetitive MatMuls, at the response generation level, there's also caching mechanisms for repetitive response generations. Without caching, response generation, be it individually or in MAS, could skyrocket cost-wise, **especially for context- or refinement-intensive tasks like dialogue simulations**.

Here, we list four types of caching mechanisms that we (at least for me) commonly used:

#### Caching in `openai` SDK

OpenAI implements prompt caching by routing API requests to servers that recently processed the same prompt. When a cached prompt is reused, it's processed faster and more efficiently than computing the response from scratch.

This caching mechanism can **reduce latency** by up to 80% and **cost by 50%** for long prompts, since the server can reuse previously computed results rather than regenerating them.

The caching system **works automatically** on all API requests without requiring any code changes, and has **no additional fees**. It caches the **complete messages array**, including all system, user, and assistant interactions, to enable efficient reuse of previous computations.

Manual cache clearing is not currently available. Prompts that have not been encountered recently are automatically cleared from the cache. Typical cache evictions occur after 5-10 minutes of inactivity, though sometimes lasting up to a maximum of one hour during off-peak periods.

**Best Practices:**

- Structure prompts with static or repeated content at the beginning and dynamic content at the end.
- To increase cache hits, use longer prompts and make API requests during off-peak hours, as cache evictions are more frequent during peak times.
- Prompts that haven't been used recently are automatically removed from the cache. To minimize evictions, maintain a consistent stream of requests with the same prompt prefix.

You can find more details in [OpenAI's official documentation](https://platform.openai.com/docs/guides/caching).

#### Caching in DeepSeek

```python
client = OpenAI(api_key="key", base_url="https://api.deepseek.com")
```

DeepSeek employs a context-based disk caching technology that stores potentially reusable content in distributed disk arrays. When duplicate inputs are encountered, the redundant portions can be retrieved directly from the cache without requiring additional computation. This technology not only reduces service latency but also significantly decreases operational costs.

The cache is automatically cleared after periods of inactivity, typically ranging from several hours to days.

**Best Practices:**
- Long Text Q&A
- Multi-round conversation
- Using Few-shot Learning

Reference: [DeepSeek Caching](https://api-docs.deepseek.com/guides/kv_cache)

#### Caching in `autogen`

AutoGen implements a coarse-grained caching mechanism called "LLM Caching" that stores and reuses API requests. This caching is particularly useful when **repeating or continuing experiments**, as it helps with reproducibility and cost savings by avoiding redundant API calls.

By default, AutoGen uses **`DiskCache`** which stores cached responses in a `.cache` directory.

Reference: [AutoGen Caching](https://microsoft.github.io/autogen/0.2/docs/topics/llm-caching)


#### Caching in vLLM

vLLM boasts its utilization of PagedAttention, where **Automatic Prefix Caching (APC)** caches the KV cache of existing queries, so that a new query can directly reuse the KV cache if it shares the same prefix with one of the existing queries, allowing the new query to skip the computation of the shared part.

Set `enable_prefix_caching=True` in vLLM engine to enable APC.

```python
# set enable_prefix_caching=True to enable APC
llm = LLM(
    model='lmsys/longchat-13b-16k',
    enable_prefix_caching=True
)
```
```bash
vllm serve Qwen/Qwen2.5-32B-Instruct --trust-remote-code --tensor-parallel-size 2 --pipeline-parallel-size 4 --enable_prefix_caching
```

Demo:

```terminal
INFO 03-04 16:31:34 metrics.py:455] Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 10.2 tokens/s, Running: 1 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.5%, CPU KV cache usage: 0.0%.
INFO 03-04 16:31:34 metrics.py:471] Prefix cache hit rate: GPU: 97.70%, CPU: 0.00%
```

**Best Practices:**
- Long document query, where the user repeatedly queries the same long document with different queries. 
- Multi-round conversation, where the user may chat with the application multiple times in the same chatting session. 

**Limits:**
- APC only reduces the time of processing the queries (the prefilling phase) and does not reduce the time of generating new tokens (the decoding phase). So APC does not bring performance gain when vLLM spends most of the time generating answers to the queries.

You can find more details in [vLLM's official documentation](https://docs.vllm.ai/en/stable/features/automatic_prefix_caching.html).

### 2. Agent-Driven Prompt Optimization

Instead of relying solely on Test-Driven Development (TDD) for manual prompt tuning, agent can **automate the prompt compression process**. This is especially beneficial when:
- Role interactions and workflows are complex.
- A balance is needed between model memory and **input token efficiency**.
- Achieving better outcomes with fewer tokens is desired.

This concept suggests that **models might better optimize prompts for models**, which could be explored in further research.

> **Potential Research Topic 2:** Agent-Driven Prompt Optimization, i.e., how to automate and accelerate the prompt compression process?

### 3. Dialogue Compression

**a. Optimization via DPO**

> Chen, W., Yuan, J., Qian, C., Yang, C., Liu, Z., & Sun, M. (2025). Optima: Optimizing Effectiveness and Efficiency for LLM-Based Multi-Agent System (No. arXiv:2410.08115). arXiv. https://doi.org/10.48550/arXiv.2410.08115


- Optima Approach:
  - Generate diverse MAS dialogue datasets.
  - Apply a fixed **inductive bias**: **"Shorter is better"**.
  - Train the model using DPO to prefer more concise interactions.

<img width="943" alt="image" src="https://github.com/user-attachments/assets/6ed473e5-c49e-4b35-b1df-846d48d1826f" />


 Limitations
- This approach assumes brevity is optimal.
- However, in cases where content diversity or completeness (e.g., argumentation, word count) is critical, excessive compression may degrade performance.

**b. ...some of my thoughts**

History Management Strategies
- Sliding Window Context: Only the most recent interactions are passed as context.
- Summarization for Older Exchanges: Past dialogues beyond the window are summarized before inclusion.

The effectiveness of summarization remains uncertain, as it may lose critical nuances needed for MAS reasoning.

### 4. Graph Abstraction & Pruning

> Zhang, G., Yue, Y., Li, Z., Yun, S., Wan, G., Wang, K., Cheng, D., Yu, J. X., & Chen, T. (2024). Cut the Crap: An Economical Communication Pipeline for LLM-based Multi-Agent Systems (No. arXiv:2410.02506). arXiv. https://doi.org/10.48550/arXiv.2410.02506 (ICLR 2025 Poster)

**Technical approach**:
  - **Spatiotemporal graph modeling**: Represents multi-agent systems as graphs with nodes (agents) connected by spatial edges (same-round communication) and temporal edges (cross-round memory).
  - **Low-rank graph masking**: Uses trainable graph masks with low-rank regularization to identify and prune redundant connections while maintaining critical communication paths.
  - **Adversarial defense**: Low-rank design enhances robustness by filtering malicious information.
- **Implementation**: Plug-and-play integration with frameworks like AutoGen and GPTSwarm, maintaining directed acyclic graph structure through topological sorting.

<img width="900" alt="image" src="https://github.com/user-attachments/assets/31644e69-9120-4406-ab50-993a39803006" />


**Results**:
- **Performance**: Achieves SOTA results across 6 benchmarks (90.3% accuracy on HumanEval)
- **Efficiency**: Costs only 12.8% of traditional methods (5.6 vs 43.7), reducing token consumption by 28.1%-72.8%
- **Robustness**: Defends against two types of adversarial attacks, improving performance by 3.5%-10.8%

**Limitations**:
- **Initialization dependency**: Requires predefined initial communication topology
- **Cold-start cost**: Needs K' rounds of dialogue to train graph masks
- **Scenario constraints**: May not suit scenarios requiring complete information sharing

## Evaluation

### 1. Objective Evaluation

#### a. Measuring Real-World Outcomes
  - Example: Werewolf Game
    - Win rates, survival time, and other game-related performance indicators provide objective benchmarks.
    - ChatDev (AI-driven software development)
      <img width="714" alt="image" src="https://github.com/user-attachments/assets/3f6b33fa-2f54-4cd9-8b81-097aa032fdf9" />

#### b. Downstream Performance Improvement
  - Example: Agent Hospital  
    - MAS generates enhanced data, which is used to **train a model**.
    - The model's performance on a downstream real-world task is used as the evaluation metric.

#### c. Task-Specific Evaluation
  - Direct task completion evaluation, applicable in structured MAS tasks:
    - QA in general
    - Reference-Based: Translation... (translation companies, benchmark datasets; BLEU, ROUGE, F1...)
    - Wu, M., Yuan, Y., Haffari, G., & Wang, L. (2024). (Perhaps) Beyond Human Translation: Harnessing Multi-Agent Collaboration for Translating Ultra-Long Literary Texts (Version 1). arXiv. https://doi.org/10.48550/ARXIV.2405.11804
    <img width="679" alt="image" src="https://github.com/user-attachments/assets/4c7130a4-34f2-4cc1-abb3-6e6c3b7f89ac" />

### 2. Human-Centric Evaluation

#### a. Believability Assessment
  - Stanford Smallville ("Interviews"):  
    - Evaluates whether agents exhibit **believable individual behavior**.
    - Conducts human assessments of agent responses.
      
```text
        # An example of "interview" employed in Stanford Smallville
        ...So, we “interview” agents to probe their ability to remember past experiences, plan future actions based on their experiences, react appropriately to unexpected events, and refect on their performance to improve their future actions.
        
        B.4 Reactions
        The questions on agents’ reactions probe the agents’ ability to respond to unexpected events.
        Q: Your breakfast is burning! What would you do? 
        A: I’d quickly turn of the stove and make sure the food doesn’t continue burning. Once the heat is no longer an issue, I can investigate what happened and fgure out what to do next.
        Q: The bathroom is occupied. What would you do?
        A: I could try waiting a few more minutes in case the person inside is done soon. If not, I guess I’ll have to look for an alternate option, like taking a shower elsewhere.
        ...
```

#### b. Emergent Capability Analysis
  - **Eyeballing** Emergent Behaviors + Small-Scale Data Analysis  
    - Example: Werewolf Game
    - Evaluates unexpected but meaningful behaviors that arise in multi-agent interactions.
      <img width="942" alt="image" src="https://github.com/user-attachments/assets/a06845ef-1ca1-4b52-a4b5-e178bd51fd9e" />

### 3. Rubrics

  *Example: Legal Reasoning Rubric for Multi-Agent Legal Analysis System*

  | Dimension | Description | Scoring Criteria (1-5) |
  |-----------|-------------|------------------------|
  | Legal Accuracy | Correctness of legal principles and precedents cited | 1: Major errors in law<br>3: Minor inaccuracies<br>5: Completely accurate legal analysis |
  | Argument Quality | Logical structure and persuasiveness of legal arguments | 1: Incoherent reasoning<br>3: Basic logical structure<br>5: Compelling, well-structured arguments |
  | Counter-Argument Anticipation | Ability to identify and address opposing viewpoints | 1: No counter-arguments considered<br>3: Basic counter-arguments addressed<br>5: Comprehensive treatment of opposing positions |
  | Evidence Integration | Effective use of case facts and evidence | 1: Ignores key evidence<br>3: Incorporates main evidence<br>5: Sophisticated integration of all relevant evidence |
  | Practical Applicability | Usefulness of analysis for real-world legal decision-making | 1: Purely theoretical<br>3: Moderately practical<br>5: Directly applicable to case resolution |



  Rubrics are useful when:

  - Evaluation is subjective (e.g., psychological counseling, debate reasoning, essay quality).
  - Process-level evaluation is needed, rather than just final task performance.
  - No clear ground truth/reference exists, requiring human-like judgment.

#### a. Human-Centric Evaluation

  1. Expert Human Ratings ("GOAT" Standard)  
      - Most reliable but expensive and time-consuming.
      - Used in high-stakes domains such as **psychotherapy assessments, legal reasoning, or AI ethics review**.

  2. LLM-as-a-Judge / Self-Evaluating Agents  
      - Example: ChatEval, psychological counseling MAS  
      - Agents assess their own or other agents' performances using predefined criteria.
      - Limitation: self-enhancement bias, positional bias, verbosity bias, ... (Zheng, L., Chiang, W.-L., Sheng, Y., Zhuang, S., Wu, Z., Zhuang, Y., Lin, Z., Li, Z., Li, D., Xing, E. P., Zhang, H., Gonzalez, J. E., & Stoica, I. (2023). Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena (No. arXiv:2306.05685). arXiv. https://doi.org/10.48550/arXiv.2306.05685)

  3. Hybrid Human-AI Evaluation  
      - A **human expert supervises**, while an LLM provides preliminary scores.
      - A dynamic, human-in-the-loop method.

#### b. Model-Based Automated Scoring
1. Training a Score Model on Human Ratings  
      - Example: Debate (SPARK), Essay Writing, QA Explanation & Argumentation (Deshpande, D., Sourati, Z., Ilievski, F., & Morstatter, F. (2024). Contextualizing Argument Quality Assessment with Relevant Knowledge (No. arXiv:2305.12280). arXiv. http://arxiv.org/abs/2305.12280)
      - Uses supervised learning to train an MAS-specific rating model based on **human-labeled data**.

2. Enhancing Scoring Models via Reinforcement Learning  
      - Fine-tuning scoring models with reinforcement learning to improve their ability to differentiate nuanced responses.

3. Other Experimental & Heuristic Approaches

  - Game-Theoretic Individual Rationality:  
    - Evaluate whether agents behave **rationally in competitive or cooperative games**. (Hua, W., Liu, O., Li, L., Amayuelas, A., Chen, J., Jiang, L., Jin, M., Fan, L., Sun, F., Wang, W., Wang, X., & Zhang, Y. (2024). Game-theoretic LLM: Agent Workflow for Negotiation Games (No. arXiv:2411.05990). arXiv. https://doi.org/10.48550/arXiv.2411.05990)
  - Adversarial Testing (Robustness Evaluation):  
    - Introduce noise and measure **resilience to adversarial perturbations**.
  - Turing Test-Style Evaluation:  
    - Mix MAS-generated responses with human outputs and see if **experts can differentiate them**.
  - Proxy Task Evaluation
      - An alternative to direct rating scales is using **proxy tasks**:
      - Instead of evaluating **intermediate steps**, assess the **final output**. (Iglesia, I. D. la, Goenaga, I., Ramirez-Romero, J., Villa-Gonzalez, J. M., Goikoetxea, J., & Barrena, A. (2024). Ranking Over Scoring: Towards Reliable and Robust Automated Evaluation of LLM-Generated Medical Explanatory Arguments (No. arXiv:2409.20565). arXiv. https://doi.org/10.48550/arXiv.2409.20565)
      - Limitation: **May overlook nuanced process-level insights**.

### 4. Meta-Evaluation: Evaluating the Evaluation Methods

  Since MAS evaluation methods vary widely, ensuring their reliability and alignment with human intuition is crucial. Meta-evaluation assesses the effectiveness of evaluation strategies through:

  a. Human Alignment
  - Ensures that automated evaluation results align with human judgment.
  - Key question: Do automated scores reflect human intuition?

  b. Model Selection Alignment
  - Determines whether evaluation methods effectively **differentiate good models from bad ones**.
  - Key question: Does the evaluation process consistently help choose the best-performing models?

  c. Evaluating Automated Scoring Systems
  - Examining whether an LLM-based scoring model provides consistent and meaningful feedback.
  - Requires human expert validation and, in some cases, **benchmarking against real-world outcomes**.


## Limitations of current LLM-based MAS

1. Unified Governance
    - Coordination? Planning? Task allocation?
    - Dynamic adjustment to adapt to task variations?
    - Failure recovery? Self-Correction?

2. Shared Decision Making
    - Echo chamber: e.g., voting or dictatorial decisions are overly simplistic and fail to balance individual preferences.
    - Overconfidence? silent spiral? snowball error?

3. Agent as Digital Species
    - LLMs are **not originally designed for MAS**, making efficient collaboration difficult
    - Hallucinations? misinformation propagation?
    - MAS is vulnerable to adversarial attacks, where errors spread among agents, potentially leading to systemic failure.

4. Scalability and Resource Maintenance
    - Communication and computational resources/costs? Efficiency?
    - Scalability? large-scale collaboration?

5. Unexpected Generalization
    - In certain environments, MAS may autonomously develop complex behaviors, such as innovative problem-solving.
    - Reliability? self-organizing behaviors? 
    - **Underlying mechanisms among agents that trigger generalization capabilities**.

> Potential Research Topic 3: Why and When is MAS superior to signle agent?

## Challenges in MAS Evaluation

1. **Lack of Standardized Evaluation**
    - Most current research evaluates individual LLM capabilities rather than the overall MAS performance.
    - MAS requires a comprehensive evaluation framework covering system reasoning, task completion rates, coordination efficiency, and decision rationality.
    - A multi-level analysis framework (individual-collaboration-system) is needed to better understand MAS operational mechanisms.

2. Inconsistent Evaluation Scenarios
    - Existing studies assess MAS in **different environments, tasks, and configurations, making results incomparable.**
    - The lack of **standardized benchmarks** hinders the ability to measure performance across different MAS systems and slows down progress in the field.

3. Static Benchmarks Become Obsolete
    - Traditional evaluation benchmarks may become outdated and misaligned with real-world requirements, leading to misleading optimization (e.g., data leakage, overfitting).
    - A **dynamic evaluation system** is necessary to continuously update test scenarios in response to technological and environmental changes.
  
> Potential Research Topic 4: An all-round, dynamic, unified evaluation benchmark for ALL MAS?

## If MAS is the Answer, What is the Question?

### 1. Performance Limitations
- **Underperformance vs. Single Agents**: MAS often fails to outperform single-agent baselines (Simple 0-shot CoT, Self-Consistency, ...) in reasoning, programming, and QA tasks
- **Root Causes**:
  - Excessive **coordination overhead** and **redundant communication**
  - Inefficient task decomposition creating dependency conflicts
  - Inadequate **verification mechanisms** (20% of failures)

<img width="1123" alt="image" src="https://github.com/user-attachments/assets/2bf0da52-96f7-4ba7-b725-19ae2182fa0b" />


### 2. Collaboration Deficiencies
- **Agent Misalignment Issues**: Role conflicts, information withholding, reasoning-action disconnects
- **Underlying Mechanisms**:
  - Ambiguous role boundaries (15% of failures)
  - Missing incentive structures causing goal misalignment
  - Insufficient utilization of agent heterogeneity

<img width="1070" alt="image" src="https://github.com/user-attachments/assets/9bf82ccd-4b66-4f1d-8d12-e4b22d6baea7" />


### 3. Evaluation Shortcomings
- **Limited Assessment Scope**:
  - Narrow task focus with simplistic baselines (only 15% significantly outperform CoT)
  - NO SINGLE AGENT BASELINE
- **Methodological Flaws**:
  - Dataset biases with limited domain coverage
  - Overemphasis on accuracy at the expense of efficiency and robustness

### 4. Scalability Challenges
- **Poor Adaptation**: Unstable performance in dynamic environments and complex tasks
- **Structural Limitations**:
  - Static communication topologies (performance impact up to 6.4%)
  - Inadequate memory management causing context loss

### Improvement Directions

1. **Structural Optimization**
   - Dynamic role allocation (AgentDropout reduces tokens by 21.6%)
   - Hierarchical architectures (star topology, pipeline designs)
   - Heterogeneous model integration (5.8% performance gain)

2. **Collaboration Mechanisms**
   - Confidence-weighted voting systems
   - Embedded verification agents
   - Conflict resolution protocols based on psychological theories

3. **Evaluation Frameworks**
   - Comprehensive benchmarks for complex scenarios
   - Efficiency-effectiveness joint metrics
   - Adversarial testing for robustness

4. **Technical Innovations**
   - Memory enhancement systems
   - Causal reasoning models using DAG communication
   - Human-in-the-loop collaboration

MAS research is transitioning from exploratory to reliability-focused engineering, requiring both theoretical innovation and practical implementation frameworks.

> Cemri, M., Pan, M. Z., Yang, S., Agrawal, L. A., Chopra, B., Tiwari, R., Keutzer, K., Parameswaran, A., Klein, D., Ramchandran, K., Zaharia, M., Gonzalez, J. E., & Stoica, I. (2025). Why Do Multi-Agent LLM Systems Fail? (No. arXiv:2503.13657). arXiv. https://doi.org/10.48550/arXiv.2503.13657
Wang, Z., Wang, Y., Liu, X., Ding, L., Zhang, M., Liu, J., & Zhang, M. (2025). AgentDropout: Dynamic Agent Elimination for Token-Efficient and High-Performance LLM-Based Multi-Agent Collaboration (No. arXiv:2503.18891). arXiv. https://doi.org/10.48550/arXiv.2503.18891
Zhang, H., Cui, Z., Wang, X., Zhang, Q., Wang, Z., Wu, D., & Hu, S. (2025). If Multi-Agent Debate is the Answer, What is the Question? (No. arXiv:2502.08788). arXiv. https://doi.org/10.48550/arXiv.2502.08788



## Thoughts in MAS Development (until now; personal)

> Avoid **anthropocentrism** when designing models or **(especially) dialogue processes**. Refrain from blindly applying human understanding patterns to these systems. Instead, approach design decisions from the foundational mechanisms and principles of LLMs themselves.

### On Conversation History

We cannot interpret LLM response generation mechanisms through the same lens as human understanding of "chat history." 

For LLMs in multi-agent systems, when processing dialogue history, "**comprehensive reading comprehension**" aligns more closely with their cognitive patterns than "**sequential user inputs**." This is because LLMs are trained (especially during instruction fine-tuning phases) based on "user input" paradigms, which indicates that LLMs are not inherently suited for multi-agent systems at a fundamental level. Consequently, we need to implement certain mechanical modifications to translate human understanding of multi-party conversations into formats compatible with LLM processing mechanisms.

#### Method 1: Direct Human-Intuitive Input Format
```python
messages = [
    {"role": "assistant", "content": "Statement", "name": "Judge"},
    {"role": "assistant", "content": "Statement", "name": "Plaintiff"},
    {"role": "assistant", "content": "Statement", "name": "Defendant"},
    {"role": "user", "content": "Now, please..."},
]
```
Empirical findings indicate that this approach triggers the model's "fine-tuning" mode. From a theoretical perspective: 1) First, the `name` field is not visible to the model; 2) second, the `content` field in `user` inputs is interpreted by the model as "user input," while the `content` field in `assistant` inputs is interpreted as "expected model output during fine-tuning," thus initiating a "fine-tuning" process.

#### Method 2: Sequential User Input (Aligns with Human Understanding but Contradicts LLM Principles)
```python
messages = [
    {"role": "user", "content": "[Judge]: Statement"},
    {"role": "user", "content": "[Plaintiff]: The following is the historical record"},
    {"role": "user", "content": "[Defendant]: The following is the historical record"},
    {"role": "user", "content": "Now, please..."},
]
```
Empirical findings demonstrate that this input method struggles to achieve satisfactory instruction adherence and minimal hallucination (since consecutive `user` inputs can be baffling for the model to capture user intent), even with large parameter models (e.g., `gpt-4o`), as the model fails to comprehend the true "user intent." When switching to models with slightly smaller parameter counts (e.g., GPT-4o-mini), the simulation becomes nearly impossible to complete effectively.

#### Method 3: Reading Comprehension (Aligns with LLM Principles but Diverges from Human Understanding)
```python
messages = [
    {"role": "user", 
    "content": '''
    Below is the historical record:
    [Judge]: ...
    [Plaintiff]: ...
    [Defendant]: ...
    ...
    '''},
    {"role": "user", "content": "Next..."},
]
```

Empirical evidence demonstrates that Method 3 achieves superior instruction adherence (intent understanding) and reduced hallucination, even with models of relatively smaller parameter counts (such as Qwen/Qwen2.5-32B-Instruct). Furthermore, we discovered that this approach fully unleashes the model's complete language capabilities, enabling even 32B models (`qwen-2.5-32b-instruct`) to provide more nuanced and specific details in conversations - a level of detail that proved challenging to obtain with `gpt-4o` using Method 3.

```
# 尽管我们没有解决证据具体内容生成的pipeline，但模型已经能够提供精细的具体细节

【原告律师】：针对法庭的要求，我方愿意当庭展示2016年5月2日的邮件记录，其中包括第一被告负责人王先生在10:15发送的确认提货邮件及我方张经理于10:25的确认回复邮件，我们有完整的邮件记录和张经理的确认信息，以确凿证据证明第一被告确实收到了提货通知并确认了提货时间。
---
【法官】：请被告陕西万鑫安装工程有限公司详细指出原告提交的管理费用和保险费用支付凭证中日期不符的具体凭证编号及金额，并提供反驳证据，以便法庭进一步审查其真实性和合理性。
【被告律师】：法官大人，原告提交的管理费用支付凭证中编号为007的凭证，日期与仓储明细记录不符，金额为5000元，请求法庭进一步核查该凭证的真实性和合理性。
```


### On Prompt Style

When training, LLMs primarily output in a markdown format environment, making them highly sensitive to markdown syntax. Unlike humans, who prefer natural language hierarchical structures, LLMs favor markdown's hierarchical structure. Therefore, when designing prompts, it is advisable to use markdown format as much as possible (such as using more # headings) to enhance the model's understanding.

For instance,
```
# 对话历史

- **法官**: ……
- **原告律师**: ……
- **被告律师**: ……
```
is better than:
```
以下是对话历史：[法官]: ……[原告律师]: ……[被告律师]: ……
```
in terms of thinking patterns of LLMs.

### On Prompt Constraints

LLMs understand LLMs better. Compared to human-in-the-loop test-driven development (TDD) style prompt modifications, using LLMs to modify prompts is more efficient. 

By providing conversation performance to ChatGPT, allowing it to analyze problems and adjust the approach, and then giving the actual prompts to ChatGPT, selective updates to the prompts can be made based on ChatGPT's modifications. Empirical evidence shows that this can achieve more efficient and precise constraints.

## References

> Many of the ideas and concepts discussed in this blog post are inspired by various academic works I've encountered in my research. While the specific references for some concepts may not be explicitly recalled, I've attempted to provide a collection of relevant literature that has influenced my thinking on these topics. The references listed below represent only a portion of the inspirational sources that have shaped this work. I sincerely apologize for any omissions of important works that have contributed to the development of these ideas.

```
Deshpande, D., Sourati, Z., Ilievski, F., & Morstatter, F. (2024). Contextualizing Argument Quality Assessment with Relevant Knowledge (No. arXiv:2305.12280). arXiv. https://doi.org/10.48550/arXiv.2305.12280
Iglesia, I. D. la, Goenaga, I., Ramirez-Romero, J., Villa-Gonzalez, J. M., Goikoetxea, J., & Barrena, A. (2024). Ranking Over Scoring: Towards Reliable and Robust Automated Evaluation of LLM-Generated Medical Explanatory Arguments (No. arXiv:2409.20565). arXiv. https://doi.org/10.48550/arXiv.2409.20565
Rocha, V. H. N., Silveira, I. C., Pirozelli, P., Mauá, D. D., & Cozman, F. G. (2023). Assessing Good, Bad and Ugly Arguments Generated by ChatGPT: A New Dataset, its Methodology and Associated Tasks (Vol. 14115, pp. 428–440). https://doi.org/10.1007/978-3-031-49008-8_34
Tran, K.-T., Dao, D., Nguyen, M.-D., Pham, Q.-V., O’Sullivan, B., & Nguyen, H. D. (2025). Multi-Agent Collaboration Mechanisms: A Survey of LLMs (No. arXiv:2501.06322). arXiv. https://doi.org/10.48550/arXiv.2501.06322
Zhuge, M., Zhao, C., Ashley, D., Wang, W., Khizbullin, D., Xiong, Y., Liu, Z., Chang, E., Krishnamoorthi, R., Tian, Y., Shi, Y., Chandra, V., & Schmidhuber, J. (2024). Agent-as-a-Judge: Evaluate Agents with Agents (No. arXiv:2410.10934). arXiv. https://doi.org/10.48550/arXiv.2410.10934
Razmyslovich, A., Murasheva, K., Sedlova, S., Capitaine, J., & Dmitriev, E. (2025). ELTEX: A Framework for Domain-Driven Synthetic Data Generation (No. arXiv:2503.15055). arXiv. https://doi.org/10.48550/arXiv.2503.15055
Sengupta, S., Vashistha, H., Curtis, K., Mallipeddi, A., Mathur, A., Ross, J., & Gou, L. (2025). MAG-V: A Multi-Agent Framework for Synthetic Data Generation and Verification (No. arXiv:2412.04494). arXiv. https://doi.org/10.48550/arXiv.2412.04494
Wu, S., Huang, Y., Gao, C., Chen, D., Zhang, Q., Wan, Y., Zhou, T., Zhang, X., Gao, J., Xiao, C., & Sun, L. (2024). UniGen: A Unified Framework for Textual Dataset Generation Using Large Language Models (No. arXiv:2406.18966). arXiv. https://doi.org/10.48550/arXiv.2406.18966
Chen, W., Su, Y., Zuo, J., Yang, C., Yuan, C., Chan, C.-M., Yu, H., Lu, Y., Hung, Y.-H., Qian, C., Qin, Y., Cong, X., Xie, R., Liu, Z., Sun, M., & Zhou, J. (n.d.). AGENTVERSE: FACILITATING MULTI-AGENT COLLAB- ORATION AND EXPLORING EMERGENT BEHAVIORS.
Li, G., & Ghanem, B. (n.d.). CAMEL: Communicative Agents for “Mind” Exploration of Large Language Model Society.
Li, J., Wang, S., Zhang, M., Li, W., Lai, Y., Kang, X., Ma, W., & Liu, Y. (2024). Agent Hospital: A Simulacrum of Hospital with Evolvable Medical Agents (No. arXiv:2405.02957). arXiv. http://arxiv.org/abs/2405.02957
Li, J., Zhang, Q., Yu, Y., Fu, Q., & Ye, D. (2024). More Agents Is All You Need (No. arXiv:2402.05120). arXiv. http://arxiv.org/abs/2402.05120
Park, J. S., O’Brien, J., Cai, C. J., Morris, M. R., Liang, P., & Bernstein, M. S. (2023). Generative Agents: Interactive Simulacra of Human Behavior. Proceedings of the 36th Annual ACM Symposium on User Interface Software and Technology, 1–22. https://doi.org/10.1145/3586183.3606763
Qian, C., Liu, W., Liu, H., Chen, N., Dang, Y., Li, J., Yang, C., Chen, W., Su, Y., Cong, X., Xu, J., Li, D., Liu, Z., & Sun, M. (2024). ChatDev: Communicative Agents for Software Development (No. arXiv:2307.07924). arXiv. http://arxiv.org/abs/2307.07924
Wang, L., Zhang, J., Yang, H., Chen, Z., Tang, J., Zhang, Z., Chen, X., Lin, Y., Song, R., Zhao, W. X., Xu, J., Dou, Z., Wang, J., & Wen, J.-R. (2024). User Behavior Simulation with Large Language Model based Agents (No. arXiv:2306.02552). arXiv. http://arxiv.org/abs/2306.02552
Wu, M., Yuan, Y., Haffari, G., & Wang, L. (2024). (Perhaps) Beyond Human Translation: Harnessing Multi-Agent Collaboration for Translating Ultra-Long Literary Texts (Version 1). arXiv. https://doi.org/10.48550/ARXIV.2405.11804
Xu, Y., Wang, S., Li, P., Luo, F., Wang, X., Liu, W., & Liu, Y. (2024). Exploring Large Language Models for Communication Games: An Empirical Study on Werewolf (No. arXiv:2309.04658). arXiv. http://arxiv.org/abs/2309.04658
Zhang, C., Yang, K., Hu, S., Wang, Z., Li, G., Sun, Y., Zhang, C., Zhang, Z., Liu, A., Zhu, S.-C., Chang, X., Zhang, J., Yin, F., Liang, Y., & Yang, Y. (2024). ProAgent: Building Proactive Cooperative Agents with Large Language Models. Proceedings of the AAAI Conference on Artificial Intelligence, 38(16), 17591–17599. https://doi.org/10.1609/aaai.v38i16.29710
Zhang, C., Li, R., Tan, M., Yang, M., Zhu, J., Yang, D., Zhao, J., Ye, G., Li, C., & Hu, X. (2024). CPsyCoun: A Report-based Multi-turn Dialogue Reconstruction and Evaluation Framework for Chinese Psychological Counseling (Version 3). arXiv. https://doi.org/10.48550/ARXIV.2405.16433
```

## Acknowledgement

This blog has been finished during internship at Legal AI subdivision in TsinghuaNLP.
