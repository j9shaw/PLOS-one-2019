%% Dual Pycnocline Tutorial Figure 2
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

           
%% Increasing D in one time slice

ii = 80; % late time



  %% Single Stack Tutorial Figure
  
D_vals = [1, 4, 6, 25, 50];
subplot_ind = 1;
ht_fact = 2.395;  % for colorbar management

    figure('position', [200, 200, fig_w , fig_h]); hold on
    clf
    set(gcf,'DefaultLineLineWidth',1.2,'DefaultTextFontSize',20,...
        'DefaultTextFontWeight','bold','DefaultAxesFontSize',25,...
          'DefaultAxesFontWeight','bold');
      
    subplot(11,1,1)
    pcolor(reshape(squeeze(data(:,ii)),3001,128)'),shading flat
    set(gca,'XTickLabel',[]);
    set(gca,'Ytick',[40,80,120])
    %colorbar
    caxis([-caxis_bd caxis_bd]/2)
    sub_pos = get(subplot(11,1,1),'Position'); % needed for making one giant colorbar: take bottom subplot
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.01  sub_pos(2)  0.01  sub_pos(4)]) %left, bottom, width, height
    
for jj = D_vals

    %% construct background
        recon = zeros(M,N);
        for kk = 1:jj
            recon=recon+bsxfun(@times,u(:,kk),coeff(kk,:)); % add modes to recon
        end
        recon = bsxfun(@plus, recon, mean(data,2)); % add mean to recon.
        
   
    subplot(11,1,subplot_ind+1)
    pcolor(reshape(squeeze(recon(:,ii)),3001,128)'),shading flat
    text(30, 105, strcat('$D = \, $', int2str(jj), ', $E = \, $' , num2str(round(sum(lambda_data(1:jj)),3))) , 'Color','white', 'Interpreter','latex') 
    set(gca,'XTickLabel',[]);
    set(gca,'Ytick',[40,80,120])    
    %colorbar
    caxis([-caxis_bd caxis_bd]/2)
    
    subplot(11,1,subplot_ind+2)
    error_temp = transpose(reshape(squeeze(data(:,ii)),3001,128)-reshape(squeeze(recon(:,ii)),3001,128));
    pcolor(error_temp),shading flat
    if jj ~= D_vals(end) %only want xticks on the very last panel
	    set(gca,'XTickLabel',[]);
    end
    set(gca,'Ytick',[40,80,120])    
    %colorbar
    text(30, 105, strcat('$D = \, $', int2str(N-jj), ', $E = \, $' , num2str(round(sum(lambda_data(jj+1:end)),3))) , 'Color','black', 'Interpreter','latex')     
    caxis([-caxis_bd caxis_bd]/2)
    
    colormap(cmocean('balance'))

    sub_pos = get(subplot(11,1,subplot_ind+2),'Position'); % needed for making one giant colorbar: take bottom subplot
    colorbar('Position', [sub_pos(1)+sub_pos(3)+0.01  sub_pos(2)  0.01  sub_pos(4)*ht_fact]) %left, bottom, width, height

    subplot_ind = subplot_ind +2;
end

            if make_figs
                figname = strcat('dual_pyc_fig_D_sweep');
                style = hgexport('factorystyle');
                hgexport(gcf,figname,style,'Format','eps')
            end 

