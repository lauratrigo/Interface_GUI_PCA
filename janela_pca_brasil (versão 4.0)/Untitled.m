% function PlotarimagemButtonPushed(app, event)
%     % 1. Verifica se os dados existem
%     if isempty(app.matrix_list)
%         uialert(app.UIFigure, 'Gere a matriz primeiro no botão Concatenar!', 'Erro de Dados');
%         return;
%     end
% 
%     % 2. Coordenadas e Nomes (Exatamente como no seu script)
%     coords = [-9.749 -36.653; -11.306 -41.859; -17.555 -39.743; -14.888 -40.803; -1.409 -48.463; 2.845 -60.701; -15.947 -47.878; -3.877 -38.426; -3.878 -38.426; -20.311 -40.319; -3.711 -38.473; -22.687 -44.985; -15.555 -56.070; -17.883 -51.726; -20.428 -51.343; -28.235 -48.656; -5.492 -47.497; -5.362 -49.122; -19.942 -43.925; -22.319 -46.328; -16.716 -43.858; -19.210 -46.133; -18.919 -48.256; -20.441 -54.541; -13.556 -52.271; -10.804 -55.456; -11.619 -50.664; -12.545 -55.727; -3.023 -60.055; -25.020 -47.925; -22.896 -43.224; -4.288 -56.036; -7.214 -35.907; -9.384 -40.506; -9.031 -42.703; -5.102 -42.793; -30.074 -51.120; -22.318 -44.327; -8.709 -63.896; -22.120 -51.409; -25.384 -51.488; -23.410 -51.938; -9.965 -67.803; -22.818 -43.306; -21.765 -41.326; -5.204 -37.325; -5.836 -35.208; -13.122 -60.544; -10.784 -65.331; -10.864 -61.960; -22.523 -52.952; -0.144 -67.058; -12.975 -38.516; -12.939 -38.432; -27.138 -52.600; -27.793 -50.304; -20.786 -49.360; -29.719 -53.717; -21.185 -50.440; -12.975 -38.516; -11.747 -49.049; -10.171 -48.331; -25.448 -49.231; -20.762 -42.870];
%     lat = coords(:,1); lon = coords(:,2);
% 
%     % 3. Cálculos PCA Dinâmicos
%     matrix_clean = app.matrix_list;
%     matrix_clean(isnan(matrix_clean)) = 0;
%     
%     [coeff, score, ~, ~, ~] = pca(matrix_clean);
% 
%     % Pega a EOF selecionada pelo usuário no EditField
%     nEOF = app.PCAEditField.Value; 
%     if nEOF > size(coeff, 2), nEOF = 1; end % Segurança
%     eof_atual = coeff(:, nEOF);
% 
%     % 4. SIMETRIZAÇÃO (Igual ao seu código)
%     % Center, Right, Top Center, Top Right, Bottom Center, Left, etc...
%     lat_all = [lat; lat; abs(lat); abs(lat); lat; abs(lat)+2*min(lat); abs(lat)+2*min(lat); abs(lat); abs(lat)+2*min(lat)];
%     lon_all = [lon; (abs(lon))+2*max(lon); lon; abs(lon)+2*max(lon); (abs(lon))+2*min(lon); lon; abs(lon)+2*max(lon); (abs(lon))+2*min(lon); (abs(lon))+2*min(lon)];
%     eof_all = repmat(eof_atual, 9, 1);
% 
%     % 5. Interpolação
%     lon_vec = linspace(min(lon_all)-1, max(lon_all)+1, 400);
%     lat_vec = linspace(min(lat_all)-1, max(lat_all)+1, 400);
%     [LonG, LatG] = meshgrid(lon_vec, lat_vec);
%     Z = griddata(lon_all, lat_all, eof_all, LonG, LatG, 'natural');
% 
%     % 6. Plotagem no App ou em Figure Nova
%     fig = figure('Color', [1 1 1]);
%     contourf(LonG, LatG, Z, 100, 'LineColor', 'none');
%     hold on;
%     colormap(jet);
%     colorbar;
% 
%     % Pontos das estações e contorno do Brasil
%     scatter(lon, lat, 30, 'k', 'filled');
% 
%     try
%         brasil = shaperead('BR_UF_2019.shp', 'UseGeoCoords', true);
%         for k = 1:length(brasil)
%             plot(brasil(k).Lon, brasil(k).Lat, 'k', 'LineWidth', 1.5);
%         end
%     catch
%         warning('Shapefile não encontrado.');
%     end
% 
%     % Limites e Labels
%     xlim([-67, -36]);
%     ylim([-30, 3]);
%     xlabel('Longitude'); ylabel('Latitude');
%     title(['Mapa Espacial EOF ', num2str(nEOF)]);
%     axis equal;
% end