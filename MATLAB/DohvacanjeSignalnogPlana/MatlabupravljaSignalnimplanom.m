function MatlabupravljaSignalnimplanom(faza, signalniPlan, Vrijemeunutarciklusa )
%Ovoj funkciji se predaje signalniplan, popis svih faza spojenih na
%upravlja�ke ure�aje i trenutno vrijeme. Matlab ru�no preuzima kontrolu nad
%ure�ajima prema dobivenom signalnom planu

[~,l] = size(faza);
        for k = 1:l
            [~,n] = size(signalniPlan.Signalniplan(k).Izmjene);
            for j = 1:n
            
                if(Vrijemeunutarciklusa == signalniPlan.Signalniplan(k).Izmjene(j).Vrijeme / 1000)
                
                    faza(k).set('AttValue', 'State', str2double(signalniPlan.Signalniplan(k).Izmjene(j).Stanje));
                end
            end
        end

end

