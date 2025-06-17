classdef mereni_z
    properties
        Mereni
        Konst
    end

    methods
        function obj=mereni_z(Mereni,konst)
            obj.Mereni=Mereni;
            obj.Konst=konst;
        end

        function [TabPostup,TabVysledky,TabChod]=zpracuj(obj,VGR)
            RTU1=arrayfun(@(x) x.mereni_prum, obj.Mereni);
            TEMP=arrayfun(@(x) x.temp, obj.Mereni);
            RTU=arrayfun(@(x) x.mereni_prum, obj.Mereni)*obj.Konst;
            id=arrayfun(@(x) x.id, obj.Mereni);
            T2=arrayfun(@(x) x.time_m, obj.Mereni);

            T=T2-T2(1);
            % p,P,gr,dgr,pdgr,H,Hp
            u=unique(id);
            p=[];
            u1 = [];
            for n=1:length(u)
                if sum(id==u(n)) > 1
                    p1 = polyfit(T(id==u(n)), RTU(id==u(n)), 1);
                    if p1(1)>0
                        p2=1;
                    elseif p1(1)<0
                        p2=-1;
                    else
                        p2=0;
                    end
                    p = [p;[p1,p2]];
                    u1 = [u1;u(n)];
                end
            end
            
            
            kle=any(p(:,3)==-1);
            rost=any(p(:,3)==1);
            if kle && rost
                error('Něco je asi špatně jeden chod roste druhý klesá')
            end
            
            P=mean(p(:,1));
            dg=-P*(T);
            
            
            gr=RTU+dg;
            dgr=zeros(1,length(RTU));
    

            r = [];
            for n = 1:length(u1)
                r = [r,find(id == u1(n))];
            end
            r = r(1);

            for n = 0:length(dgr)-1
                dgr(n+1)=gr(r)-gr(n+1);
            end

            pdgr=mean(abs(dgr));

            H=dgr/VGR;
            Hp=mean(abs(H));

            
            TabPostup=table(id',T2',T',TEMP',RTU1',RTU',dg',gr',[dgr'],round([H'],1));
            TabPostup.Properties.VariableNames={'Číslo bodu','Absolutní čas','Relativní čas','Teplota','Průměrné čtení','Relativní tíhové údaje','Oprava z chodu gravimetru','Opravené relativní tíhové údaje','Tíhové rozdíly','Výškový rozdíl ~0.1m'};
            TabPostup.Properties.Description = 'Zpracování měření pomocí relativního gravimetru:';
            TabPostup.Properties.VariableUnits = {'-','min','min','°C','dílek','mGal','mGal','mGal','mGal','m'};

            TabVysledky=table(P,pdgr,round(Hp,1));
            TabVysledky.Properties.VariableNames={'Průměrná oprava z chodu gravimetru','Průměrný tíhový rozdíl','Průměrný výškový rozdíl ~0.1m'};
            TabVysledky.Properties.Description = 'Výsledky gravimetrického měřní, pouze pro dva body, jinak potřeba manuálně dopočítat';
            TabVysledky.Properties.VariableUnits= {'mGal/min','mGal','m'};

            TabChod=table(u1,p(:,1),p(:,2));
            TabChod.Properties.VariableNames={'Číslo bodu','a','b'};
            TabChod.Properties.Description='Výsledné parametry proložených přímek na bodech';
            TabChod.Properties.VariableUnits= {'-','mGal/min','mGal'};
        end

        function vytvor_grafy(obj)
            RTU=arrayfun(@(x) x.mereni_prum, obj.Mereni)*obj.Konst;
            id=arrayfun(@(x) x.id, obj.Mereni);
            T=arrayfun(@(x) x.time_m, obj.Mereni);
            
            T=T-T(1);
            u=unique(id);
            p=zeros(length(u),2);
            
            for n=1:length(u)
                if sum(id==u(n)) > 1
                    Q=T(id==u(n));
                    p(n,:) = polyfit(T(id==u(n)), RTU(id==u(n)), 1);
                    Cas=T(id==u(n));
                    RT=RTU(id==u(n));
                    int=T(id==u(n));
                    int=[int(1)-15,int(end)+15];
                    obj.graf(int,RT,Cas,p(n,:),u(n),u(n))
                end
            end
        end
    end

    methods (Access = private)
        function graf(obj, int, RT, Cas, P, u, n)
            figure(n)
            plot(Cas,RT,LineStyle="none",Marker="x",Color='k',MarkerSize=10)
            hold on
            plot(int,P(1,1)*int+P(1,2),Color='r',LineWidth=1)
            title(['Chod stroje na bodě číslo: ', num2str(u)])
            ylabel("Relativní tíhový údaj g_r' [mGal]")
            xlabel('Čas \DeltaT[min]')
            xlim(int)
            ylim(P(1,1)*int+P(1,2))
            grid on
            ax = gca;
            ax.Position(2) = ax.Position(2) + 0.09;
            ax.Position(4) = ax.Position(4) - 0.1;
            
            captionText = sprintf('gr''= %f* \\Deltat + %f', P(1,1), P(1,2));
            annotation('textbox', [0.3, 0.05, 0.4, 0.05], 'String', captionText, ...
                       'EdgeColor', 'none', 'HorizontalAlignment', 'center');
            hold off
        end
    end

end