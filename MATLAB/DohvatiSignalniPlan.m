% Funkcija za èitanje podataka o signalnom planu iz .sig filea predaje
% Strukturiranu varijablu koja sadrzi signalni plan
% Objasnjenje stanja: 1 - crveno, 2 - crvenozuto, 3 - zeleno, 4- zuto

function [izlaz] = DohvatiSignalniPlan(filename)

ucitanipodaci = parseXML(filename); %èitanje podataka iz .sig i prebacivanje u struct

metapodaci = ucitanipodaci.Children(10).Children(2).Attributes; % opci podaci: trajanje cikulsa, switchpoint, offset, naziv raskrižja

podacipofazama = ucitanipodaci.Children(10).Children(2).Children(2).Children; %ne prociscena lista faza
[m,n] = size(podacipofazama); % broj redova u matrici
brojfaza = (n - 1) / 2; % izracun broja stvarnih faza


j = 1;
for i=2:2:n
prociscenefaze(j) = struct('Nazivfaze', ucitanipodaci.Children(6).Children(i).Attributes(3).Value, 'Idfaze', podacipofazama(i).Attributes(1).Value, 'Vrsta', podacipofazama(i).Attributes(2).Value, 'Izmjene', podacipofazama(i).Children(2).Children, 'Fiksnipodaci', podacipofazama(i).Children(4).Children);
j = j+1;

end

for g=1:brojfaza
    [m, n] = size(prociscenefaze(g).Izmjene);
    k = 1;
    for i=2:2:n
        izmjena (k)= struct('Vrijeme', prociscenefaze(g).Izmjene(i).Attributes(1).Value, 'Stanje', prociscenefaze(g).Izmjene(i).Attributes(2).Value);
        k = k + 1;
    end
    if(prociscenefaze(g).Vrsta == '3')
    prociscenefazeipromjene(g) = struct('Nazivfaze', prociscenefaze(g).Nazivfaze, 'Idfaze', prociscenefaze(g).Idfaze, 'Vrsta', prociscenefaze(g).Vrsta, 'Izmjene', izmjena, 'TrajanjeZutocrvenog', prociscenefaze(g).Fiksnipodaci(2).Attributes(2).Value, 'TrajanjeZutog', prociscenefaze(g).Fiksnipodaci(4).Attributes(2).Value);
    end
    if(prociscenefaze(g).Vrsta == '4')
        prociscenefazeipromjene(g) = struct('Nazivfaze', prociscenefaze(g).Nazivfaze, 'Idfaze', prociscenefaze(g).Idfaze, 'Vrsta', prociscenefaze(g).Vrsta, 'Izmjene', izmjena, 'TrajanjeZutocrvenog', 0, 'TrajanjeZutog', 0);
    end
end

for i=1:brojfaza
    [m, n] = size(prociscenefazeipromjene(i).Izmjene);
    for j=1:n
        if (prociscenefazeipromjene(i).Vrsta == '3')
        if (prociscenefazeipromjene(i).Izmjene(j).Stanje == '3')
            prociscenefazeipromjene(i).Izmjene(n+1).Stanje = '2';
            if (str2num(prociscenefazeipromjene(i).Izmjene(j).Vrijeme) - str2num(prociscenefazeipromjene(i).TrajanjeZutocrvenog) < 0)
                prociscenefazeipromjene(i).Izmjene(n+1).Vrijeme = str2num(metapodaci(1).Value) + str2num(prociscenefazeipromjene(i).Izmjene(j).Vrijeme) - str2num(prociscenefazeipromjene(i).TrajanjeZutocrvenog);
            end
            if (str2num(prociscenefazeipromjene(i).Izmjene(j).Vrijeme) - str2num(prociscenefazeipromjene(i).TrajanjeZutocrvenog) >= 0)
            prociscenefazeipromjene(i).Izmjene(n+1).Vrijeme = str2num(prociscenefazeipromjene(i).Izmjene(j).Vrijeme) - str2num(prociscenefazeipromjene(i).TrajanjeZutocrvenog);
            end
        end
        if (prociscenefazeipromjene(i).Izmjene(j).Stanje == '1')
            prociscenefazeipromjene(i).Izmjene(n+1).Stanje = '4';
            if (str2num(prociscenefazeipromjene(i).Izmjene(j).Vrijeme) - str2num(prociscenefazeipromjene(i).TrajanjeZutog) < 0)
                prociscenefazeipromjene(i).Izmjene(n+1).Vrijeme = str2num(metapodaci(1).Value) + str2num(prociscenefazeipromjene(i).Izmjene(j).Vrijeme) - str2num(prociscenefazeipromjene(i).TrajanjeZutog);
            end
            if (str2num(prociscenefazeipromjene(i).Izmjene(j).Vrijeme) - str2num(prociscenefazeipromjene(i).TrajanjeZutog) >= 0)
            prociscenefazeipromjene(i).Izmjene(n+1).Vrijeme = str2num(prociscenefazeipromjene(i).Izmjene(j).Vrijeme) - str2num(prociscenefazeipromjene(i).TrajanjeZutog);
            end
        end
        [m, n] = size(prociscenefazeipromjene(i).Izmjene);
        end
    end
end

for i=1:brojfaza
    [m, n] = size(prociscenefazeipromjene(i).Izmjene);
    for j=1:n
        if(~isnumeric(prociscenefazeipromjene(i).Izmjene(j).Vrijeme))
        prociscenefazeipromjene(i).Izmjene(j).Vrijeme = str2num(prociscenefazeipromjene(i).Izmjene(j).Vrijeme);
        end
    end
end

izlaz = struct('Metapodaci', metapodaci, 'Signalniplan', prociscenefazeipromjene);

end


