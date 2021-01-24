function G_t(t, gamma, rewards)
	discounted = [rewards[t+i] * gamma ^ (i-1) for i in 1:length(rewards)-t]
	return sum(discounted)
end
