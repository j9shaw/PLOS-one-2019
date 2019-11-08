%% Collision Data Set Results
clear all, close all;
load collision_data.mat
rho = rhostrim;

caxis_max_rho = max(rho(:));
caxis_min_rho = min(rho(:));
caxis_bd_rho = max([abs(caxis_max_rho);abs(caxis_min_rho)]);

%error map
num_modes = size(rho,3);
tic
[error_map]=eof_error_map(reshape(rhostrim,3072*81,150),num_modes);
toc

error_max = max(error_map(:));
times = [20, 55, 75, 93];
fig_w = 3000;
fig_h = 1500;
def_font_size = 20;
make_figs = 1;


%% Data set with error map            

    figure('position', [200, 200, fig_w , fig_h]); 
    set(gcf,'DefaultLineLineWidth',6,'DefaultTextFontSize',def_font_size,...
        'DefaultTextFontWeight','bold','DefaultAxesFontSize',def_font_size+5,...
          'DefaultAxesFontWeight','bold');
for ii = 1:4
    
    subplot(5,1,ii)
    pcolor(rho(:,:,times(ii))'),shading flat
    text(25, 72, strcat('$t = \, $', int2str(times(ii))), 'Color','white', 'Interpreter','latex') 
    caxis([-caxis_bd_rho caxis_bd_rho]) % for rho
    if ii ~= 4 %only want xticks on the very last subplot
        set(gca,'XTickLabel',[]);
    end    
    sub_pos = get(subplot(5,1,ii),'Position'); %left, bottom, width, height
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.01  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height
    
end

    subplot(5,1,5)
    imagesc(error_map)
    set(gca,'YDir','normal')
    ylh=ylabel('$D$','Interpreter', 'LaTeX')
      ylh.Position(2) = ylh.Position(2) - 5;  %left, bottom, width, height
      ylh.Position(1) = ylh.Position(1) - 0.4;  %left, bottom, width, height  
    set(get(gca,'YLabel'),'Rotation',0)
    xlabel('$t$','Interpreter', 'LaTeX')
    % first time
    line([times(1) times(1)], [1 floor(0.15*num_modes)],'Color','green');
    line([times(1) times(1)], [floor(0.85*num_modes) num_modes],'Color','green');
    % first time
    line([times(2) times(2)], [1 floor(0.15*num_modes)],'Color','green');
    line([times(2) times(2)], [floor(0.85*num_modes) num_modes],'Color','green');
    % first time
    line([times(3) times(3)], [1 floor(0.15*num_modes)],'Color','green');
    line([times(3) times(3)], [floor(0.85*num_modes) num_modes],'Color','green');
    % first time
    line([times(4) times(4)], [1 floor(0.15*num_modes)],'Color','green');
    line([times(4) times(4)], [floor(0.85*num_modes) num_modes],'Color','green');   
    ylim([1 num_modes]) % max modes for y.

    caxis([0,error_max])
    sub_pos = get(subplot(5,1,5),'Position'); %left, bottom, width, height
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.01  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height
    
    colormap(cmocean('balance')) %Thyng et al. 2016 perceptually uniform colormap.

            if make_figs
                figname = strcat('coll_evol_fig_results');
                style = hgexport('factorystyle');
                hgexport(gcf,figname,style,'Format','eps')
            end
