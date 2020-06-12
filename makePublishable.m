function makePublishable(latexflg)
%% MAKEPUBLISHABLE The function modifies graphic properties
%   This function when called after making a plot, updates the graphic
%   properties to a fixed standard. Version 1 of this function is just
%   targeted for making plots consistent for LaTeX based papers and thesis.
%   INPUT ARGUMENTS:
%   latexflg: String input that helps choose if the plots have to be
%   formatted with a LaTeX interpreter or not. 0 -> No, 1 -> Yes.

fig = gcf;      % Get's the current figure handle
chld = get(gcf,'Children');
if ~isempty(chld)
    flag = 1;   % Multiplot
    chld_len = length(chld);
else
    flag = 0;   % Singleplot
end

switch flag
    case 0
        if latexflg == 1
            fig.CurrentAxes.XLabel.Interpreter = 'latex';
            fig.CurrentAxes.YLabel.Interpreter = 'latex';
            fig.CurrentAxes.YLabel.Interpreter = 'latex';
        end
        
        fig.CurrentAxes.XLabel.FontSize = 14;   %originally: 14, 24
        fig.CurrentAxes.YLabel.FontSize = 14;
        fig.CurrentAxes.YLabel.FontSize = 14;
        fig.CurrentAxes.FontName = 'Helvetica';
        fig.CurrentAxes.FontWeight = 'bold';
    case 1
        for i = 1:chld_len
            if chld(i).Type == "axes"    
                if latexflg == 1
                    fig.Children(i).TickLabelInterpreter = 'latex';
                    fig.Children(i).XLabel.Interpreter = 'latex';
                    fig.Children(i).YLabel.Interpreter = 'latex';
                    fig.Children(i).ZLabel.Interpreter = 'latex';
                    fig.Children(i).Title.Interpreter = 'latex';
                end
                fig.Children(i).FontName = 'Helvetica';
                fig.Children(i).FontWeight = 'bold';
                fig.Children(i).FontSize = 14;
                fig.Children(i).LineWidth = 2;      % originally: 2  
                fig.Children(i).Box = 'on';
                if ~isempty(fig.Children(i).Children)
                    for j = 1:length(fig.Children(i).Children)
                        fig.Children(i).Children(j).LineWidth = 2;
                    end
                end
                if ~isempty(fig.Children(i).YAxis)
                    for k = 1:length(fig.Children(i).YAxis)
                        fig.Children(i).YAxis(k).Color = [0.15 0.15 0.15];
                    end
                end
            elseif chld(i).Type == "legend"
                if latexflg == 1
                    fig.Children(i).Interpreter = 'latex';
                end
                fig.Children(i).FontSize = 14;
                fig.Children(i).FontName = 'Helvetica';
                if ~isempty(fig.Children(i).Children)
                    for j = 1:length(fig.Children(i).Children)
                        fig.Children(i).Children(j).LineWidth = 2;
                    end
                end
            elseif chld(i).Type == "heatmap"
                fig.Children(i).FontSize = 14;
                fig.Children(i).FontName = 'Arial'; 
                fig.Children(i).CellLabelFormat = '%0.3g';
            end           
        end
end
end



