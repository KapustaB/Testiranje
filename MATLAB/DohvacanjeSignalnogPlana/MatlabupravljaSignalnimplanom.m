function MatlabupravljaSignalnimplanom(faza, signalniPlan, Vrijemeunutarciklusa )
%Ovoj funkciji se predaje signalniplan, popis svih faza spojenih na
%upravljaèke ureðaje i trenutno vrijeme. Matlab ruèno preuzima kontrolu nad
%ureðajima prema dobivenom signalnom planu

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

