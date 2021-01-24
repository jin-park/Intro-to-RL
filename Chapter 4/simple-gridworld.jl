function s_prime(s) # s′
    gridworld = [0 1 2 3; 4 5 6 7; 8 9 10 11; 12 13 14 0]
    a = s ÷ 4 + 1
    b = s % 4 + 1
    return [gridworld[clamp(a-1, 1, 4), b], 
     gridworld[clamp(a+1, 1, 4), b], 
     gridworld[a, clamp(b-1, 1, 4)], 
     gridworld[a, clamp(b+1, 1, 4)]]
end

function pi(a) # π(a|s) always 0.25
    0.25
end

function reward(s) # r
    if s == 0
        return 0
    else
        return -1
    end
end

function short(x)
    return round(x, digits=2)
end

function display_v_π(v_π)
    line(value) = " $("$(value)"*(" "^(7 - length("$value")))) |"
    for i in 1:4
        print("|")
        for j in 1:4
            if i == 4 && j == 4
                print(line(short(v_π[1])))
            else
                print(line(short(v_π[4*(i-1)+j])))
            end
        end
        println()
    end
end

function evaluate_policy() # policy evaluation in-place
    θ = 0
    Δ = θ + 1.0 # just initiating Δ as bigger than θ; doesn't mean anything
    S = collect(1:14)
    gridworld = [0 1 2 3; 4 5 6 7; 8 9 10 11; 12 13 14 0]
    v_π = zeros(15)
    while Δ > θ
        Δ = 0
        for s ∈ S # non terminal states
            v = v_π[s + 1]
            v_π[s + 1] = sum(0.25 * [reward(s′) + v_π[s′ + 1] for s′ in s_prime(s)])
            Δ = maximum([Δ, abs(v - v_π[s + 1])])
        end
    end
    println("_________________________________________")
    display_v_π(v_π)
    println("_________________________________________")
end

function evaluate_policy_two() # policy evaluation with two arrays
    θ = 0
    Δ = θ + 1.0 # just initiating Δ as bigger than θ; doesn't mean anything
    S = collect(1:14)
    gridworld = [0 1 2 3; 4 5 6 7; 8 9 10 11; 12 13 14 0]
    v_π = zeros(15)
    v_π_previous = zeros(15)
    while Δ > θ
        Δ = 0
        for s ∈ S # non terminal states
            v = v_π_previous[s + 1]
            v_π[s + 1] = sum(0.25 * [reward(s′) + v_π_previous[s′ + 1] for s′ in s_prime(s)])
            Δ = maximum([Δ, abs(v - v_π[s + 1])])
        end
        v_π_previous = v_π
    end
    println("_________________________________________")
    display_v_π(v_π)
    println("_________________________________________")
end

function compare_inplace_and_two_array_version()
    println("policy evaluation: in-place")
    println()
    evaluate_policy()
    println()
    println("policy evaluation: two arrays")
    println()
    evaluate_policy_two()
    println()
end
