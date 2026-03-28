function matriz = gerar_matriz_TEC(dias_escolhidos)

files = {'ALAR-2011-08(01-31).txt', 'BAIR-2011-08(01-31).txt', 'BATF-2011-08(01-31).txt', 'BAVC-2011-08(01-31).txt', 'BELE-2011-08(01-31).txt', 'BOAV-2011-08(01-31).txt', ...
    'BRAZ-2011-08(01-31).txt', 'BRFT-2011-08(01-31).txt', 'CEEU-2011-08(01-31).txt', 'CEFE-2011-08(01-31).txt', 'CEFT-2011-08(01-31).txt', 'CHPI-2011-08(01-31).txt', ...
    'CUIB-2011-08(01-31).txt', 'GOJA-2011-08(01-31).txt', 'ILHA-2011-08(01-31).txt', 'IMBT-2011-08(01-31).txt', 'IMPZ-2011-08(01-31).txt', 'MABA-2011-08(01-31).txt', ...
    'MGBH-2011-08(01-31).txt', 'MGIN-2011-08(01-31).txt', 'MGMC-2011-08(01-31).txt', 'MGRP-2011-08(01-31).txt', 'MGUB-2011-08(01-31).txt', 'MSCG-2011-08(01-31).txt', ...
    'MTCN-2011-08(01-31).txt', 'MTCO-2011-08(01-31).txt', 'MTSF-2011-08(01-31).txt', 'MTSR-2011-08(01-31).txt', 'NAUS-2011-08(01-31).txt', 'NEIA-2011-08(01-31).txt', ...
    'ONRJ-2011-08(01-31).txt', 'PAIT-2011-08(01-31).txt', 'PBCG-2011-08(01-31).txt', 'PEPE-2011-08(01-31).txt', 'PISR-2011-08(01-31).txt', 'PITN-2011-08(01-31).txt', ...
    'POAL-2011-08(01-31).txt', 'POLI-2011-08(01-31).txt', 'POVE-2011-08(01-31).txt', 'PPTE-2011-08(01-31).txt', 'PRGU-2011-08(01-31).txt', 'PRMA-2011-08(01-31).txt', ...
    'RIOB-2011-08(01-31).txt', 'RIOD-2011-08(01-31).txt', 'RJCG-2011-08(01-31).txt', 'RNMO-2011-08(01-31).txt', 'RNNA-2011-08(01-31).txt', 'ROCD-2011-08(01-31).txt', ...
    'ROGM-2011-08(01-31).txt', 'ROJI-2011-08(01-31).txt', 'ROSA-2011-08(01-31).txt', 'SAGA-2011-08(01-31).txt', 'SALU-2011-08(01-31).txt', 'SAVO-2011-08(01-31).txt', ...
    'SCCH-2011-08(01-31).txt', 'SCLA-2011-08(01-31).txt', 'SJRP-2011-08(01-31).txt', 'SMAR-2011-08(01-31).txt', 'SPAR-2011-08(01-31).txt', 'SSA1-2011-08(01-31).txt', ...
    'TOGU-2011-08(01-31).txt', 'TOPL-2011-08(01-31).txt', 'UFPR-2011-08(01-31).txt', 'VICO-2011-08(01-31).txt'};

horas_por_dia = 1440;

for i = 1:length(files)

    fid = fopen(files{i},'rt');
    raw = textscan(fid,'%s','Delimiter','\n','HeaderLines',1);
    fclose(fid);

    txt = raw{1};

    txt = strrep(txt,',','.');
    txt = strrep(txt,'-999.0','NaN');

    data = cellfun(@str2num,txt,'UniformOutput',false);
    data = cell2mat(data);

    media = data(:,1);

    vtec = data(:,5:2:end);
    vtec = reshape(vtec',[],1);

    media_expand = repmat(media,31,1);

    diffTEC = vtec - media_expand;

    idx = [];

    for d = dias_escolhidos
        inicio = (d-1)*horas_por_dia + 1;
        fim = d*horas_por_dia;
        idx = [idx inicio:fim];
    end

    matriz(:,i) = diffTEC(idx);

end
end