classdef Mereni_j
    properties
        id (1,1) 
        time (1,2) 
        temp (1,1)
        mereni (:,1)
        mereni_prum
        time_m
    end

    methods
        function obj = Mereni_j(id, time, temp, mereni)
            obj.id = id;
            obj.time = time;
            obj.temp = temp;
            obj.mereni = mereni;
            obj.mereni_prum = mean(mereni);
            obj.time_m=time(1)*60+time(2);
        end
    end
end