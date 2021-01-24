using Distributions
using StatsPlots
theme(:juno)

function generate_q()
	gaussian = Normal(0, 1)
	q_initial = rand(gaussian, 10) 
	q_initial .-= mean(q_initial)
	q = [rand(Normal(q_initial[i], 1), 100000) for i in 1:10] 
	return q
end

argmax(q) = rand(findall(x->x==maximum(q), q))

q = generate_q()

# Agents definition

abstract type AbstractAgent end
	
mutable struct GreedyAgent <: AbstractAgent
	q_estimates::Array{Float64}
	action::Int64
	action_count::Array{Int64}
	rewards::Array{Float64}
	iteration::Int64
end

GreedyAgent(
	;q_estimates=zeros(10),
	action=0, 
	action_count=zeros(10), 
	rewards=zeros(1000), 
	iteration=0
) = GreedyAgent(q_estimates, action, action_count, rewards, iteration)

mutable struct EpsilonGreedyAgent <: AbstractAgent
	q_estimates::Array{Float64}
	action::Int64
	epsilon::Float64
	action_count::Array{Int64}
	rewards::Array{Float64}
	iteration::Int64
end

EpsilonGreedyAgent(
	epsilon
	;q_estimates=zeros(10),
	action=0,
	action_count=zeros(10),
	rewards=zeros(1000),
	iteration=0
) = EpsilonGreedyAgent(q_estimates, action, epsilon, action_count, rewards, iteration)

percentages(optimal) = [sum(optimal[1:i]) / i for i in 1:length(optimal)] .* 100

function update!(agent::AbstractAgent, reward)
	agent.action_count[agent.action] += 1
	agent.q_estimates[agent.action] += reward / agent.action_count[agent.action]
	agent.rewards[agent.iteration] = reward
end

function run(q)
	agent = GreedyAgent()
	optimal = zeros(1000)
	for i in 1:1000
		agent.iteration = i
		agent.action = argmax(agent.q_estimates)
		rewards = map(rand, q)
		reward = rewards[agent.action] 
		update!(agent, reward) 	  
		optimal[i] = reward == maximum(rewards) ? 1 : 0
	end
	return agent.rewards, percentages(optimal)
end

function run(q, epsilon::Float64)
	agent = EpsilonGreedyAgent(epsilon)
	optimal = zeros(1000)
	for i in 1:1000
		agent.iteration = i
		agent.action = rand() < epsilon  ? rand(1:10) : argmax(agent.q_estimates)
		rewards = map(x->rand(x), q)
		reward = rewards[agent.action]
		update!(agent, reward)
		optimal[i] = reward == maximum(rewards) ? 1 : 0
	end
	return agent.rewards, percentages(optimal)
end

function get_greedy_results(n::Int64) # n runs
	average_rewards = optimal = zeros(1000) # 1000 time steps
	for i in 1:n
		result_one, result_two = run(q)
		average_rewards += result_one
		optimal += result_two
	end
	average_rewards /= n
	optimal /= n
	return average_rewards, optimal
end

function get_epsilon_greedy_results(n::Int64, epsilon::Float64)
	average_rewards = optimal = zeros(1000)
	for i in 1:n
		result_one, result_two = run(q, epsilon)
		average_rewards += result_one
		optimal += result_two
	end
	average_rewards /= n
	optimal /= n
	return average_rewards, optimal
end

function compare_agents() 
	greedy_rewards, _ = get_greedy_results(5000) # epsilon = 0.1 and 0.01
	epsilon_rewards_one, _ = get_epsilon_greedy_results(5000, 0.1) # averaged over 5000 runs
	epsilon_rewards_two, _ = get_epsilon_greedy_results(5000, 0.01)
	plot(greedy_rewards, legend=:bottomright, label="Greedy")
	plot!(epsilon_rewards_one, label="ϵ = 0.1")
	plot!(epsilon_rewards_two, label="ϵ = 0.01")
end

#function plot_optimal_actions()
#	greedy_rewards, greedy_optimal = 
