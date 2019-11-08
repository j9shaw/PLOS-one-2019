%% Dual Pycnocline Tutorial Figure 3
clear all, close all;
load dual_pyc_data.mat
rho = reshape(myrhos,3001*128,100);
data = rho; data_name = 'rho';


make_figs = 1;
def_font_size = 20;
fig_w = 3000;
fig_h = 1500;
caxis_max = max(data(:));
caxis_min = min(data(:));
caxis_bd = max([caxis_max;abs(caxis_min)]);

[M,N] = size(data);

        %% EOF
        data_temp = bsxfun(@minus, data, mean(data,2)); % remove mean

        %% Compute EOFs by svds
        [u,s,v]=svds(data_temp/sqrt(N-1),N); % perform the SVD, v is not used.
        % the columns of u are the eigenvectors.
        lambda_data = diag(s).^2; % the singular values need to be squared to match the eigenvalues from pca.
        % but svd ensures they're already in decreasing order.

        %% Find timeseries coefficients
        coeff=u'*data_temp; % project the mean centered data onto the basis, size M x N
        lambda_data = lambda_data./sum(lambda_data); %normalize scree
        coeff_full_series = sum(coeff.^2,1); % total energy at every timestep

%% early time   

ii = 20; %early time

% low number of modes
jj =25;

        % construct background
        recon = zeros(M,N);
        for kk = 1:jj
            recon=recon+bsxfun(@times,u(:,kk),coeff(kk,:)); % add modes to recon
        end
        recon = bsxfun(@plus, recon, mean(data,2)); % add mean to recon.

            
    figure('position', [200, 200, fig_w , fig_h]); hold on
    clf
    set(gcf,'DefaultLineLineWidth',1.2,'DefaultTextFontSize',def_font_size,...
        'DefaultTextFontWeight','bold','DefaultAxesFontSize',def_font_size+5,...
          'DefaultAxesFontWeight','bold');

    subplot(5,2,1)
    pcolor(reshape(squeeze(data(:,ii)),3001,128)'),shading flat
    set(gca,'XTickLabel',[]);
    caxis([-caxis_bd caxis_bd])
    sub_pos = get(subplot(5,2,1),'Position'); % needed for colorbar manipulation
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height
    
    subplot(5,2,3)
    pcolor(reshape(squeeze(recon(:,ii)),3001,128)'),shading flat
    text(50, 105, strcat('$D = \, $', int2str(jj), ', $E = \, $' , num2str(round(sum(lambda_data(1:jj)),4))) , 'Color','white', 'Interpreter','latex')     
    set(gca,'XTickLabel',[]);
    caxis([-caxis_bd caxis_bd])
    sub_pos = get(subplot(5,2,3),'Position'); 
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height  
    
    subplot(5,2,5)
    error_temp = transpose(reshape(squeeze(data(:,ii)),3001,128)-reshape(squeeze(recon(:,ii)),3001,128));
    pcolor(error_temp),shading flat
    text(50, 105, strcat('$D = \, $', int2str(N-jj), ', $E = \, $' , num2str(round(sum(lambda_data(jj+1:end)),4))) , 'Color','black', 'Interpreter','latex')
    set(gca,'XTickLabel',[]);
    caxis([-caxis_bd caxis_bd]/5)
    sub_pos = get(subplot(5,2,5),'Position'); 
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height    
            
% high number of modes recon        
jj =85;

        recon = zeros(M,N);
        for kk = 1:jj
            recon=recon+bsxfun(@times,u(:,kk),coeff(kk,:)); % add modes to recon
        end
        recon = bsxfun(@plus, recon, mean(data,2)); % add mean to recon.

    subplot(5,2,7)
    pcolor(reshape(squeeze(recon(:,ii)),3001,128)'),shading flat
    text(50, 105, strcat('$D = \, $', int2str(jj), ', $E = \, $' , num2str(round(sum(lambda_data(1:jj)),4))) , 'Color','white', 'Interpreter','latex') 
    set(gca,'XTickLabel',[]);
    caxis([-caxis_bd caxis_bd])
    sub_pos = get(subplot(5,2,7),'Position'); 
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height  
    
    subplot(5,2,9)
    error_temp = transpose(reshape(squeeze(data(:,ii)),3001,128)-reshape(squeeze(recon(:,ii)),3001,128));
    pcolor(error_temp),shading flat
    text(50, 105, strcat('$D = \, $', int2str(N-jj), ', $E = \, $' , num2str(round(sum(lambda_data(jj+1:end)),4))) , 'Color','black', 'Interpreter','latex')       
    caxis([-caxis_bd caxis_bd]/50)
    sub_pos = get(subplot(5,2,9),'Position'); 
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height     
    
drawnow          
            
%% late time   

ii = 80; %late time

% low number of modes
jj =25;

        % construct background
        recon = zeros(M,N);
        for kk = 1:jj
            recon=recon+bsxfun(@times,u(:,kk),coeff(kk,:)); % add modes to recon
        end
        recon = bsxfun(@plus, recon, mean(data,2)); % add mean to recon.


    subplot(5,2,2)
    pcolor(reshape(squeeze(data(:,ii)),3001,128)'),shading flat
    set(gca,'XTickLabel',[]);
    caxis([-caxis_bd caxis_bd])
    sub_pos = get(subplot(5,2,2),'Position'); % needed for colorbar manipulation
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height
    
    subplot(5,2,4)
    pcolor(reshape(squeeze(recon(:,ii)),3001,128)'),shading flat
    text(50, 105, strcat('$D = \, $', int2str(jj), ', $E = \, $' , num2str(round(sum(lambda_data(1:jj)),4))) , 'Color','white', 'Interpreter','latex')     
    set(gca,'XTickLabel',[]);
    caxis([-caxis_bd caxis_bd])
    sub_pos = get(subplot(5,2,4),'Position'); 
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height  
    
    subplot(5,2,6)
    error_temp = transpose(reshape(squeeze(data(:,ii)),3001,128)-reshape(squeeze(recon(:,ii)),3001,128));
    pcolor(error_temp),shading flat
    text(50, 105, strcat('$D = \, $', int2str(N-jj), ', $E = \, $' , num2str(round(sum(lambda_data(jj+1:end)),4))) , 'Color','black', 'Interpreter','latex')
    set(gca,'XTickLabel',[]);
    caxis([-caxis_bd caxis_bd]/5)
    sub_pos = get(subplot(5,2,6),'Position'); 
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height    
            
% high number of modes recon        
jj =85;

        recon = zeros(M,N);
        for kk = 1:jj
            recon=recon+bsxfun(@times,u(:,kk),coeff(kk,:)); % add modes to recon
        end
        recon = bsxfun(@plus, recon, mean(data,2)); % add mean to recon.

    subplot(5,2,8)
    pcolor(reshape(squeeze(recon(:,ii)),3001,128)'),shading flat
    text(50, 105, strcat('$D = \, $', int2str(jj), ', $E = \, $' , num2str(round(sum(lambda_data(1:jj)),4))) , 'Color','white', 'Interpreter','latex') 
    set(gca,'XTickLabel',[]);
    caxis([-caxis_bd caxis_bd])
    sub_pos = get(subplot(5,2,8),'Position'); 
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height  
    
    subplot(5,2,10)
    error_temp = transpose(reshape(squeeze(data(:,ii)),3001,128)-reshape(squeeze(recon(:,ii)),3001,128));
    pcolor(error_temp),shading flat
    text(50, 105, strcat('$D = \, $', int2str(N-jj), ', $E = \, $' , num2str(round(sum(lambda_data(jj+1:end)),4))) , 'Color','black', 'Interpreter','latex')       
    caxis([-caxis_bd caxis_bd]/50)
    sub_pos = get(subplot(5,2,10),'Position'); 
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.005  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height     
    
    colormap(cmocean('balance')) %Thyng et al. 2016 perceptually uniform colormap.

            if make_figs
                figname = strcat('dual_pyc_time_tut');
                style = hgexport('factorystyle');
                hgexport(gcf,figname,style,'Format','eps')
            end
            
            

