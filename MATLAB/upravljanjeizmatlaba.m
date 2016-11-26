clear all;
clc;
filename = 'C:\Users\Kapusta\Documents\MATLAB\Testiranje signalnih planova\VISSIM\proba1.sig'; %putanja do dokumenta

signalniPlan = DohvatiSignalniPlan(filename);

% Otvaranje Vissim COM servera
vissim = actxserver('VISSIM.Vissim.900');

% Ucitavanje mreze
vissim.LoadNet('C:\Users\Kapusta\Documents\MATLAB\Testiranje signalnih planova\VISSIM\proba.inpx');
vissim.LoadLayout('C:\Users\Kapusta\Documents\MATLAB\Testiranje signalnih planova\VISSIM\proba.layx');

% Globalna varijabla za pristupanje simulaciji (objekt simulacije)
sim = vissim.Simulation;

% Globalna varijabla za pristupanje mreži
vnet = vissim.Net;

% Postavljanje simulacijskog vremena i koraka
period_time = 1500;
sim.set('AttValue', 'SimPeriod', period_time);
step_time = 1;
sim.set('AttValue', 'SimRes', step_time);


% Postavljanje signalnih skupina
sigController=vnet.SignalControllers;
sigGroup=sigController.ItemByKey(1);    % Signalna skupina 1
sgs=sigGroup.SGs;          % Postavljanje faza prema ID-evima kojima pripadaju
  faza(1)=sgs.ItemByKey(1);   % Faza 1 V1
  faza(2)=sgs.ItemByKey(2);   % Faza 2 V2
  faza(3)=sgs.ItemByKey(3);   % Faza 3 V3
  faza(4)=sgs.ItemByKey(4);   % Faza 4 V4

Vrijemeunutarciklusa = 0;
COMControlEnabled = false;

switchPoint = str2double(signalniPlan.Metapodaci(7).Value);

for i = 0:(period_time*step_time)
    sim.RunSingleStep;  % Running  step-by-step
    pause(0.05) %300ms
    
    % Test provjera trenutne sekunde trajanja simulacije
    trenutno_vrijeme=sim.get('AttValue',  'SimSec');
    disp(trenutno_vrijeme)
    
    %poziv funkcije za ruèno upravljanje
    if(COMControlEnabled)
        MatlabupravljaSignalnimplanom(faza, signalniPlan, Vrijemeunutarciklusa);
    end
    
    %prestanak ruènog upravljanja na prvom switchpointu nakon trenutnog
    %vremena 400
    if (trenutno_vrijeme >= 400 && Vrijemeunutarciklusa == switchPoint / 1000)
        COMControlEnabled = false;
        [~,l] = size(faza);
        for v=1:l
            faza(v).set('AttValue', 'ContrByCOM', false);
        end
        
    end
    
    %odreðivanje u kojem trenutku se prebacuje na upravljanje matlabom
    if(trenutno_vrijeme == 250)
        COMControlEnabled = true;
    end

    %Odreðivanje vremena unutar ciklusa
    Vrijemeunutarciklusa = Vrijemeunutarciklusa + 1;
    if (Vrijemeunutarciklusa == str2double(signalniPlan.Metapodaci(1).Value) /1000)
     Vrijemeunutarciklusa = 0;
    end
    
    disp(Vrijemeunutarciklusa)
    % Ispis trenutnih faza na raskrizju
    trenutna_faza1=faza(1).get('AttValue','State');
    disp(trenutna_faza1)
end
%Zatvaranje VISSIM COM servera i VISSIM GUI-a
%vissim.release;
disp('Kraj')


