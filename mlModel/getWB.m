%% given a SVM model, this computes the plane data which seperates calss A and class B
function [w,b] = getWB(labelA, labelB, model)

    indexA = find(model.Label == labelA);
    indexB = find(model.Label == labelB);
    
    %indexA = labelA + 1;
    %indexB = labelB + 1;
    
    if(indexA > indexB)
        [indexB, indexA] = deal(indexA, indexB);
    end
      
    cutoffs = zeros(length(model.nSV),1);
    count = 0;
    for i = 1:length(model.nSV)
       cutoffs(i+1) = count + model.nSV(i);
       count = count + model.nSV(i);
    end
    
    rangeA = cutoffs(indexA)+1:(cutoffs(indexA+1));
    rangeB = cutoffs(indexB)+1:(cutoffs(indexB+1));
    
    svs = [model.SVs(rangeA,:); model.SVs(rangeB,:)];
    coef = [model.sv_coef(rangeA,indexB-1); model.sv_coef(rangeB,indexA)];
    
    w = svs'*coef;
    bIndex = ismember(sortrows(combnk(1:model.nr_class,2)), [indexA,indexB], 'rows');
    b = model.rho(bIndex);
end
