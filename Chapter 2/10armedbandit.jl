### A Pluto.jl notebook ###
# v0.12.3

using Markdown
using InteractiveUtils

# ╔═╡ 824d919e-0d65-11eb-21f7-d7621891ff84
begin
	using Distributions
	using StatsPlots
end

# ╔═╡ 679e5d4c-0f68-11eb-130d-a9136b6be69a
# begin
# 	using Pkg
# 	Pkg.add("Plots")
# 	Pkg.add("Distributions")
#	Pkg.add("StatsPlots")
# end

# ╔═╡ dd8f5a96-0f69-11eb-274d-a5a0d7e258c2
# In case you don't have the packages installed 

# ╔═╡ 1c489a02-0ebd-11eb-2e19-3d2af261cecf
begin 
	n = 1000
	α = 0.01
	weights = [α*(1-α)^i for i in 0:n-1]
	plot(weights, label=false, lw=3, title="Weights over time")
end

# ╔═╡ 44868fc8-0ebe-11eb-3ac5-0f82862655c6
sum(weights) + (1-α)^n # Recency weighted average

# ╔═╡ 5d00323e-0ddd-11eb-0fef-990bbc6ca1b3
function generate_initial_conditions(n::Int64)
	# Generates initial conditions for n actions 
	gaussian = Normal(0, 4)
	qstar = rand(gaussian, n)
	return [rand(Normal(i, 2), 500000) for i in qstar]
end

# ╔═╡ 70549562-0f6a-11eb-0d5a-6b8d6026c0b4
initial = [rand(Normal(i, 2), 50000) for i in rand(Normal(0, 1), 10)]

# ╔═╡ 179de7ce-0f6b-11eb-1d3d-1b16752f8ebb
begin
	violin(initial, legend=false, color=:gray, border=false)
	hline!([0], linestyle=:dash)
end

# ╔═╡ 6f8f1aa4-1027-11eb-17e0-2179973bf065
mutable struct Agent
	x::Int64
	y::Int64
end

# ╔═╡ Cell order:
# ╠═679e5d4c-0f68-11eb-130d-a9136b6be69a
# ╠═dd8f5a96-0f69-11eb-274d-a5a0d7e258c2
# ╟─824d919e-0d65-11eb-21f7-d7621891ff84
# ╠═1c489a02-0ebd-11eb-2e19-3d2af261cecf
# ╠═44868fc8-0ebe-11eb-3ac5-0f82862655c6
# ╠═5d00323e-0ddd-11eb-0fef-990bbc6ca1b3
# ╠═70549562-0f6a-11eb-0d5a-6b8d6026c0b4
# ╠═179de7ce-0f6b-11eb-1d3d-1b16752f8ebb
# ╠═6f8f1aa4-1027-11eb-17e0-2179973bf065
