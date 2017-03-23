function [Tact]=Tempdata(Month,Td)

if Month == 1
    Tact = (6.11*cos((Td+1)*.2618)+(6.17+(7.17-6.17).*rand(1,length(Td))));
else if Month == 2
    Tact = 6.67*cos((Td+1)*.2618)+(8.39+(9.39-8.39).*rand(1,length(Td)));
else if Month == 3
    Tact = 6.94*cos((Td+1)*.2618)+(12.28+(13.28-12.28).*rand(1,length(Td)));
else if Month == 4
    Tact = 7.22*cos((Td+1)*.2618)+(17.28+(18.28-17.28).*rand(1,length(Td)));
else if Month == 5
    Tact = 6.94*cos((Td+1)*.2618)+(21.167+(22.167-21.167).*rand(1,length(Td)));
else if Month == 6
    Tact = 6.11*cos((Td+1)*.2618)+(25.61+(26.61-25.61).*rand(1,length(Td)));
else if Month == 7
    Tact = 5.83*cos((Td+1)*.2618)+(27.28+(28.28-27.28).*rand(1,length(Td)));
else if Month == 8
    Tact = 5.56*cos((Td+1)*.2618)+(26.72+(27.72-26.72).*rand(1,length(Td)));
else if Month == 9
    Tact = 5.83*cos((Td+1)*.2618)+(23.39+(24.39-23.39).*rand(1,length(Td)));
else if Month == 10
    Tact = 6.67*cos((Td+1)*.2618)+(17.29+(18.29-17.29).*rand(1,length(Td)));
else if Month == 11
    Tact = 7.22*cos((Td+1)*.2618)+(12.29+(13.29-12.29).*rand(1,length(Td)));
else Month == 12
    Tact = 6.39*cos((Td+1)*.2618)+(7.83+(8.83-7.83).*rand(1,length(Td)));
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
end