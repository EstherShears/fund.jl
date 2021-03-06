﻿using Mimi

@defcomp impactforests begin
    regions = Index()

    forests = Variable(index=[time,regions])

    forbm = Parameter(index=[regions])
    gdp90 = Parameter(index=[regions])
    pop90 = Parameter(index=[regions])

    acco2 = Parameter(index=[time])

    income = Parameter(index=[time,regions])
    population = Parameter(index=[time,regions])
    temp = Parameter(index=[time,regions])

    forel = Parameter()
    fornl = Parameter()
    co2pre = Parameter()
    forco2 = Parameter()
end


function run_timestep(s::impactforests, t::Int)
    v = s.Variables
    p = s.Parameters
    d = s.Dimensions

    if t>1
        for r in d.regions
            ypc = 1000.0 * p.income[t, r] / p.population[t, r]
            ypc90 = p.gdp90[r] / p.pop90[r] * 1000.0

            # TODO -oDavid Anthoff: RT uses -lP.forel for ppp case
            v.forests[t, r] = p.forbm[r] * p.income[t, r] * (ypc / ypc90)^p.forel * (0.5 * p.temp[t, r]^p.fornl + 0.5 * log(p.acco2[t - 1] / p.co2pre) * p.forco2)

            if v.forests[t, r] > 0.1 * p.income[t, r]
                v.forests[t, r] = 0.1 * p.income[t, r]
            end
        end
    end
end
