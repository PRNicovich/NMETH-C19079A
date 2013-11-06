% For plotting and stats following Analysis_structures.  

%%%%%%%%%%% Vector color designations for the different plots.  This needs
%%%%%%%%%%% to match things later, but stuff can be changed, added, etc in
%%%%%%%%%%% order to keep colors consistient across fields. Default is also
%%%%%%%%%%% included here for those that aren't included in the list below.

Vector_color.Instants{1} = [0.7 0.4 0.4]; % growth speed
Vector_color.Instants{2} = [0.4 0.55 0.7]; % pause speed
Vector_color.Instants{3} = [0.4 0.7 0.4]; % catastrophe speed
Vector_color.Stats.fgap_freq_length = [0.55 0.55 0.7];
Vector_color.Stats.bgap_freq_length = [0.4 0.7 0.7];
Vector_color.Stats.fgap_freq_time = [0.55 0.55 0.7];
Vector_color.Stats.bgap_freq_time = [0.4 0.7 0.7];
Vector_color.Stats.growth_lifetime_mean_std = [0.7 0.4 0.4];
Vector_color.Stats.fgap_lifetime_mean_std = [0.55 0.55 0.7];
Vector_color.Stats.bgap_lifetime_mean_std = [0.4 0.7 0.7];
Vector_color.Instant_sums = [0.7 0.7 0.7];
Vector_color.Detects_by_cell = [0.4 0.55 0.4];
Vector_color.Stats.percentTimeGrowth = [0.7 0.4 0.4];
Vector_color.Stats.percentTimeFgap = [0.4 0.55 0.7];
Vector_color.Stats.percentTimeBgap = [0.4 0.7 0.4];
Vector_color.Stats.growth_speed_median = [0.7 0.4 0.4];
Vector_color.Stats.fgap_speed_median = [0.4 0.55 0.7];
Vector_color.Stats.bgap_speed_median = [0.4 0.7 0.4];
Vector_color.Stats.growth_speed_mean_std = [0.7 0.4 0.4];
Vector_color.Stats.fgap_speed_mean_std = [0.4 0.55 0.7];
Vector_color.Stats.bgap_speed_mean_std = [0.4 0.7 0.4];


Vector_color.Default = [0.2 0.2 0.2];

St = [5 12 15 16 21 24 25 26 27 28]; % Number of which stats to plot
%St = [St  2 3 9 10 18 19];


%%%%%%%%%%% For when you only want to plot some of the fields
% 
% Results_all = Results;
% 
% Fields_to_use = [1 2 5 6];
% 
% Results = Results_all(Fields_to_use);
% 
% for k = 1:length(Fields_to_use);
%     
%     Results(k).Detects_by_cell = Results(k).Detects_by_cell(:,Fields_to_use);
%     
% end

%%%%%%%% Add in other values where needed

%%%%%%%%%%%% Instants plot
% Make three total - Growth, Fgap, and Bgap

% For each one you have to collect the values out of Results structure

val_inq = zeros(6, length(Results));

for k = 1:length(Results);
    
        val_inq(:,k) = structfun(@length, Results(k).Instants);
end



Inst.Growth_vector = zeros(max(val_inq(1,:)),numel(val_inq(1,:)));
Inst.Fgap_vector = zeros(max(val_inq(1,:)),numel(val_inq(1,:)));
Inst.Bgap_vector = zeros(max(val_inq(1,:)),numel(val_inq(1,:)));

Fieldnames_plot = cell(1,length(Results));

for k = 1:length(Results)
    
    Inst.Growth_vector(1:length(Results(k).Instants.growth), k) = Results(k).Instants.growth;
    Inst.Fgap_vector(1:length(Results(k).Instants.forward_gap), k) = Results(k).Instants.forward_gap;
    Inst.Bgap_vector(1:length(Results(k).Instants.backward_gap), k) = abs(Results(k).Instants.backward_gap); % flip so it's a positive speed
    
    Fieldnames_plot{k} = Results(k).name; % Watch the order of this for later!
    
end

%%%%%%%%%%%%%%%%%%%  For plusTip_heat_map
% Intialize junk for later visualization with heat map

Heat_map_fieldnames = Fieldnames_plot;

Heat_matrix = [];
Heat_stats = [];

Heat_variable = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    Inst.Growth_vector(Inst.Growth_vector == 0) = NaN;
    Inst.Fgap_vector(Inst.Fgap_vector == 0) = NaN;
    Inst.Bgap_vector(Inst.Bgap_vector == 0) = NaN;

Inst_fields = fieldnames(Inst);
Inst_names = {'Growth Speed (\mum/min)' 'Pause Speed (\mum/min)' 'Catastrophe Speed (\mum/min)'};

for k = 1:length(Inst_fields)
    bp_f = figure(10+k);
    hold off
    MyLabels = Fieldnames_plot(length(Fieldnames_plot):-1:1);
    %MyLabels = {'RNAi 250 nM', 'RNAi 100 nM', 'RNAi 50 nM', 'Control'};
    bp = boxplot(Inst.(Inst_fields{k}), 'notch','on', 'labels', MyLabels, 'labelorientation', 'inline');
    ylabel(sprintf('Instant Vector %s', Inst_names{k}));
    set(bp, 'linewidth', 1.5, 'Color', Vector_color.Instants{k});
    % change visibility of box plots here
    set(bp(7,:),'Visible','off')

    h = findobj(gca);% to get a handle to the objects
    children = get(h(2),'children');%In my case boxplot happens to be the second object of the plot.
    % for i = 1:length(MyLabels)
    % set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
    % end

    %Get the hggroup
    hg1 = get(gca,'Children');
    %Get the text annotations
    ch2 = findobj(hg1,'type','text');
    %Modify position settings. This may be done programmatically or interactively
    set(ch2,'Units','data');

    for i = 1:length(MyLabels)
    set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
    set(ch2(i),'Position',[i,-18,0]);
    end

    %Make a new hggroup with the repositioned text annotations
    copyobj(hg1,gca);
    %delete the first hggroup
    delete(hg1);

    % Color in boxes
     h = findobj(gca,'Tag','Box');
     for j=1:length(h)
        patch(get(h(j),'XData'),get(h(j),'YData'),Vector_color.Instants{k},'FaceAlpha',.4);
     end
     
    hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For plusTip_heat_map

Heat_matrix = [Heat_matrix; nanmedian(Inst.(Inst_fields{k}))];
Heat_variable{length(Heat_variable)+1} = sprintf('Inst.%s', Inst_fields{k});


end

%%%%%%%%%%%% F_vector
% Make three total - Growth, Fgap, and Bgap

% For each one you have to collect the values out of Results structure

val_inq = zeros(6, length(Results));

for k = 1:length(Results);
    
        val_inq(:,k) = structfun(@length, Results(k).F_vector);
end



F.Growth_vector = zeros(max(val_inq(1,:)),numel(val_inq(1,:)));
F.Fgap_vector = zeros(max(val_inq(1,:)),numel(val_inq(1,:)));
F.Bgap_vector = zeros(max(val_inq(1,:)),numel(val_inq(1,:)));

Fieldnames_plot = cell(1,length(Results));

for k = 1:length(Results)
    
    F.Growth_vector(1:length(Results(k).F_vector.growth), k) = Results(k).F_vector.growth;
    F.Fgap_vector(1:length(Results(k).F_vector.forward_gap), k) = Results(k).F_vector.forward_gap;
    F.Bgap_vector(1:length(Results(k).F_vector.backward_gap), k) = Results(k).F_vector.backward_gap; 
    
    Fieldnames_plot{k} = Results(k).name; % Watch the order of this for later!
    
end

    F.Growth_vector(F.Growth_vector == 0) = NaN;
    F.Fgap_vector(F.Fgap_vector == 0) = NaN;
    F.Bgap_vector(F.Bgap_vector == 0) = NaN;

F_fields = fieldnames(F);
F_names = {'Growth Speed (\mum/min)' 'Pause Speed (\mum/min)' 'Catastrophe Speed (\mum/min)'};

for k = 1:length(F_fields)
    bp_f = figure(20+k);
    hold off
    MyLabels = Fieldnames_plot(length(Fieldnames_plot):-1:1);
    %MyLabels = {'RNAi 250 nM', 'RNAi 100 nM', 'RNAi 50 nM', 'Control'};
    bp = boxplot(F.(F_fields{k}), 'notch','on', 'labels', MyLabels, 'labelorientation', 'inline');
    ylabel(sprintf('F Vector %s', F_names{k}));
    set(bp, 'linewidth', 1.5, 'Color', Vector_color.Instants{k});
    % change visibility of box plots here
    set(bp(7,:),'Visible','off')

    h = findobj(gca);% to get a handle to the objects
    children = get(h(2),'children');%In my case boxplot happens to be the second object of the plot.
    % for i = 1:length(MyLabels)
    % set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
    % end

    %Get the hggroup
    hg1 = get(gca,'Children');
    %Get the text annotations
    ch2 = findobj(hg1,'type','text');
    %Modify position settings. This may be done programmatically or interactively
    set(ch2,'Units','data');

    for i = 1:length(MyLabels)
    set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
    set(ch2(i),'Position',[i,-12,0]);
    end

    %Make a new hggroup with the repositioned text annotations
    copyobj(hg1,gca);
    %delete the first hggroup
    delete(hg1);

    % Color in boxes
     h = findobj(gca,'Tag','Box');
     for j=1:length(h)
        patch(get(h(j),'XData'),get(h(j),'YData'),Vector_color.Instants{k},'FaceAlpha',.4);
     end
 
    hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For plusTip_heat_map

Heat_matrix = [Heat_matrix; nanmedian(F.(F_fields{k}))];
Heat_variable{length(Heat_variable)+1} = sprintf('F.%s', F_fields{k});

end


%%%%%%%% Start chewing through the big pile of Stats values you have to
%%%%%%%% play with.  

Stats_fields = fieldnames(Results(1).Stats_total);


Stats_color_fieldnames = fieldnames(Vector_color.Stats);



for k = 1:length(St);
    
    val_inq = zeros(length(Stats_fields), length(Results));

    for p = 1:length(Results);
    
        val_inq(:,p) = structfun(@length, Results(p).Stats_total);
        
    end
    
    Box_cum = zeros(max(val_inq(k,:)), length(Results));
    
    for p = 1:length(Results)
        
        Box_cum(1:length(Results(p).Stats_total.(Stats_fields{St(k)})), p) = Results(p).Stats_total.(Stats_fields{St(k)})(:,1);
        
    end
    
    Box_cum(Box_cum == 0) = NaN;
    Vector_color_here = Vector_color.Default;
    
    if sum(strcmp(Stats_color_fieldnames, (Stats_fields{St(k)}))) == 1 
        
        Vector_color_here = Vector_color.Stats.(Stats_fields{St(k)});
        
    end
    
	bp_f = figure(30+St(k));
    hold off
    MyLabels = Fieldnames_plot(length(Fieldnames_plot):-1:1);
    %MyLabels = {'RNAi 250 nM', 'RNAi 100 nM', 'RNAi 50 nM', 'Control'};
    bp = boxplot(Box_cum, 'notch','on', 'labels', MyLabels, 'labelorientation', 'inline');
    ylabel(strrep(Stats_fields{St(k)}, '_', '\_'));
    set(bp, 'linewidth', 1.5, 'Color', Vector_color_here);
    % change visibility of box plots here
    set(bp(7,:),'Visible','off')

    h = findobj(gca);% to get a handle to the objects
    children = get(h(2),'children');%In my case boxplot happens to be the second object of the plot.
    % for i = 1:length(MyLabels)
    % set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
    % end

    %Get the hggroup
    hg1 = get(gca,'Children');
    %Get the text annotations
    ch2 = findobj(hg1,'type','text');
    %Modify position settings. This may be done programmatically or interactively
    set(ch2,'Units','data');

    for i = 1:length(MyLabels)
    set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
    set(ch2(i),'Position',[i,-12,0]);
    end

    %Make a new hggroup with the repositioned text annotations
    copyobj(hg1,gca);
    %delete the first hggroup
    delete(hg1);

    % Color in boxes
     h = findobj(gca,'Tag','Box');
     for j=1:length(h)
        patch(get(h(j),'XData'),get(h(j),'YData'),Vector_color_here,'FaceAlpha',.4);
     end
 
    hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For plusTip_heat_map

Heat_matrix = [Heat_matrix; nanmedian(Box_cum)];
Heat_variable{length(Heat_variable)+1} = Stats_fields{St(k)};

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Poly rate
val_inq = zeros(1, length(Results));

for k = 1:length(Results);
    
        val_inq(k) = length(Results(k).Instant_sums);
end

Instant_sums = zeros(max(val_inq), numel(val_inq));

for p = 1:length(Results)
        
	Instant_sums(1:length(Results(p).Instant_sums), p) = Results(p).Instant_sums;
        
end

Instant_sums(Instant_sums == 0) = NaN;

bp_f = figure(60);
hold off
MyLabels = Fieldnames_plot(length(Fieldnames_plot):-1:1);
%MyLabels = {'RNAi 250 nM', 'RNAi 100 nM', 'RNAi 50 nM', 'Control'};
bp = boxplot(Instant_sums, 'notch','on', 'labels', MyLabels, 'labelorientation', 'inline');
ylabel('Total Polymerization Rate ( \mum min^{-1} \mum^{-2})');
set(bp, 'linewidth', 1.5, 'Color', Vector_color.Instant_sums);
set(bp(7,:),'Visible','off')

h = findobj(gca);% to get a handle to the objects
children = get(h(2),'children');%In my case boxplot happens to be the second object of the plot.
% for i = 1:length(MyLabels)
% set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
% end

%Get the hggroup
hg1 = get(gca,'Children');
%Get the text annotations
ch2 = findobj(hg1,'type','text');
%Modify position settings. This may be done programmatically or interactively
set(ch2,'Units','data');

for i = 1:length(MyLabels)
set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
set(ch2(i),'Position',[i,-.5,0]);
end

%Make a new hggroup with the repositioned text annotations
copyobj(hg1,gca);
%delete the first hggroup
delete(hg1);

% Color in boxes
 h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),Vector_color.Instant_sums,'FaceAlpha',.4);
 end

 
hold off


% For plusTip_heat_map

Heat_matrix = [Heat_matrix; nanmedian(Instant_sums)];
Heat_variable{length(Heat_variable)+1} = 'Total Polymerization Rate';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Comet Density
val_inq = zeros(1, length(Results));

for k = 1:length(Results);
    
        val_inq(k) = length(Results(k).Detects_by_cell);
end

Detects_by_cell = zeros(max(val_inq), numel(val_inq));
% 
% for p = 1:length(Results)
%         
% 	Detects_by_cell(1:length(Results(p).Detects_by_cell), p) = Results(p).Detects_by_cell;
%         
% end

Detects_by_cell = Results(1).Detects_by_cell;
Detects_by_cell(Detects_by_cell == 0) = NaN;

bp_f = figure(61);
hold off
MyLabels = Fieldnames_plot(length(Fieldnames_plot):-1:1);
%MyLabels = {'RNAi 250 nM', 'RNAi 100 nM', 'RNAi 50 nM', 'Control'};
bp = boxplot(Detects_by_cell, 'notch','on', 'labels', MyLabels, 'labelorientation', 'inline');
ylabel('Comet Density ( \mum^{-2})');
set(bp, 'linewidth', 1.5, 'Color', Vector_color.Detects_by_cell);
set(bp(7,:),'Visible','off')

h = findobj(gca);% to get a handle to the objects
children = get(h(2),'children');%In my case boxplot happens to be the second object of the plot.
% for i = 1:length(MyLabels)
% set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
% end

%Get the hggroup
hg1 = get(gca,'Children');
%Get the text annotations
ch2 = findobj(hg1,'type','text');
%Modify position settings. This may be done programmatically or interactively
set(ch2,'Units','data');

for i = 1:length(MyLabels)
set(children(i), 'FontSize', 14); %, 'FontName','Whatever');%To change label properties
set(ch2(i),'Position',[i,-.05,0]);
end

%Make a new hggroup with the repositioned text annotations
copyobj(hg1,gca);
%delete the first hggroup
delete(hg1);

% Color in boxes
 h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),Vector_color.Detects_by_cell,'FaceAlpha',.4);
 end

 
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
Heat_matrix = [Heat_matrix; nanmedian(Detects_by_cell)];
Heat_variable{length(Heat_variable)+1} = 'Comet Density';    
    
%%%%% Statistics - All a big pile of 2-variable T-tests.  Figure this is
%%%%% the way to go but it is not hard to add another value now that the
%%%%% distributions are easy to get a hold of.  

%%%%% Added in ranksum function for Mann-Whitney U-test.

for m = 1:length(Results);
    
    Ranksum = [];
    TTest = [];
    
    % Instant 
    
    TTest_fields = fieldnames(Inst);
    for p = 1:length(TTest_fields)
    
        for k = 1:size(Inst.(TTest_fields{p}), 2)
            for j = 1:size(Inst.(TTest_fields{p}), 2)
            
            [h,g,ci] = ttest2(Inst.(TTest_fields{p})(:,k),Inst.(TTest_fields{p})(:,j),[],[],'unequal');
 
            TTest(k, j) = g;
            Same(k, j) = h;            
                        
            RS_test_1 = Inst.(TTest_fields{p})(~isnan(Inst.(TTest_fields{p})(:,k)),k);
            RS_test_2 = Inst.(TTest_fields{p})(~isnan(Inst.(TTest_fields{p})(:,j)),j);
            
            [m, n, stats_dummy] = ranksum(RS_test_1, RS_test_2);
            
            Ranksum(k, j) = m;
            Ranksame(k, j) = n;
        
            end
        end
        
        Results(m).TTest.Instants.(TTest_fields{p}) = TTest;
        Results(m).Ranksum.Instants.(TTest_fields{p}) = Ranksum;
        
    end
	Ranksum = [];
    TTest = [];
    
        % F
    
    TTest_fields = fieldnames(F);
    for p = 1:length(TTest_fields)
    
        for k = 1:size(F.(TTest_fields{p}), 2)
            for j = 1:size(F.(TTest_fields{p}), 2)
            
            [h,g,ci] = ttest2(F.(TTest_fields{p})(:,k),F.(TTest_fields{p})(:,j),[],[],'unequal');
 
            TTest(k, j) = g;
            Same(k, j) = h;
            
            RS_test_1 = F.(TTest_fields{p})(~isnan(F.(TTest_fields{p})(:,k)),k);
            RS_test_2 = F.(TTest_fields{p})(~isnan(F.(TTest_fields{p})(:,j)),j);
            
            [m, n, stats_dummy] = ranksum(RS_test_1, RS_test_2);
            
            Ranksum(k, j) = m;
            Ranksame(k, j) = n;
        
            end
        end
    
        Results(m).TTest.F.(TTest_fields{p}) = TTest;
        Results(m).Ranksum.F.(TTest_fields{p}) = Ranksum;
    
    end
    
	Ranksum = [];
    TTest = [];
    
        % Detects_by_cell
    
    % No need for field names, so this and Instant_sums doesn't iterate
    % over fields 

    for k = 1:size(Detects_by_cell, 2)
            for j = 1:size(Detects_by_cell, 2)
            
            [h,g,ci] = ttest2(Detects_by_cell(:,k),Detects_by_cell(:,j),[],[],'unequal');
 
            TTest(k, j) = g;
            Same(k, j) = h;
            
            RS_test_1 = Detects_by_cell(~isnan(Detects_by_cell(:,k)),k);
            RS_test_2 = Detects_by_cell(~isnan(Detects_by_cell(:,j)),j);
            
            [m, n, stats_dummy] = ranksum(RS_test_1, RS_test_2);
            
            Ranksum(k, j) = m;
            Ranksame(k, j) = n;
            
        
            end
    end
    
        Results(m).TTest.Detects_by_cell = TTest;
        Results(m).Ranksum.Detects_by_cell = Ranksum;

    
	Ranksum = [];
    TTest = [];
        
        % Instant_sums 
    
    
        for k = 1:size(Instant_sums, 2)
            for j = 1:size(Instant_sums, 2)
            
            [h,g,ci] = ttest2(Instant_sums(:,k),Instant_sums(:,j),[],[],'unequal');
 
            TTest(k, j) = g;
            Same(k, j) = h;
            
            RS_test_1 = Instant_sums(~isnan(Instant_sums(:,k)),k);
            RS_test_2 = Instant_sums(~isnan(Instant_sums(:,j)),j);
            
            [m, n, stats_dummy] = ranksum(RS_test_1, RS_test_2);
            
            Ranksum(k, j) = m;
            Ranksame(k, j) = n;
        
            end
        end
    
        Results(m).TTest.Instant_sums = TTest;  
        Results(m).Ranksum.Instant_sums = Ranksum;
        
        
                % All the stats
    
    TTest_fields = fieldnames(Results(1).Stats_total);
    for p = 1:length(TTest_fields)
        
    Ranksum = [];
    TTest = [];
        
    
        for k = 1:size(Results, 2)
            for j = 1:size(Results, 2)
            
            [h,g,ci] = ttest2(Results(k).Stats_total.(TTest_fields{p})(:,1),Results(j).Stats_total.(TTest_fields{p})(:,1),[],[],'unequal');
 
            TTest(k, j) = g;
            Same(k, j) = h;
            
            RS_test_1 = Results(k).Stats_total.(TTest_fields{p})(~isnan(Results(k).Stats_total.(TTest_fields{p})(:,1)),1);
            RS_test_2 = Results(j).Stats_total.(TTest_fields{p})(~isnan(Results(j).Stats_total.(TTest_fields{p})(:,1)),1);
            
            [m, n, stats_dummy] = ranksum(RS_test_1, RS_test_2);
            
            Ranksum(k, j) = m;
            Ranksame(k, j) = n;
        
            end
        end
    
        Results(m).TTest.Stats_total.(TTest_fields{p}) = TTest;
        Results(m).Ranksum.Stats_total.(TTest_fields{p}) = Ranksum;
    
    end

end

% %%%%%%%%%%%%%%%%%%%%%%%%%% Heat Map plot
figure(28)
Heat_map((Heat_matrix-1), Heat_map_fieldnames, Heat_variable, [],...
    'Colormap', 'money', 'TickAngle', 45, 'ShowAllTicks', 1, 'ColorBar', 1)
ylabel('Heat Map');

