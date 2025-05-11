classdef ImageColourisationApp < matlab.apps.AppBase
        
    % Properties (UI components)
    properties (Access = public)
        % General components
        UIFigure       matlab.ui.Figure
        GridLayout     matlab.ui.container.GridLayout
        ControlLayout  matlab.ui.container.GridLayout
        ImOrig         matlab.ui.control.Image
        ImGrey         matlab.ui.control.Image
        ImOG           matlab.ui.control.Image
        ImRec          matlab.ui.control.Image
        BtnGen         matlab.ui.control.Button
        BtnInput       matlab.ui.control.Button
        BtnOutput      matlab.ui.control.Button
        BtnParSet      matlab.ui.control.Button
        % Colour generation components
        SelectPanel    matlab.ui.container.Panel  % Selection area
        SelectLayout   matlab.ui.container.GridLayout % Panel layout
        BtnGroup       matlab.ui.container.ButtonGroup  % Radio button group
        BtnUniformed   matlab.ui.control.RadioButton  % Uniformed radio button
        BtnRandom      matlab.ui.control.RadioButton  % Random radio button
        % BtnDraw        matlab.ui.control.RadioButton
        BtnSelect      matlab.ui.control.RadioButton
        BtnAct         matlab.ui.control.Button  % Draw radio button
        TextField      
        

        % Popup window components
        PopFigure      matlab.ui.Figure
        PopSelectIm    matlab.ui.control.Image 
        PopFigurePar   matlab.ui.Figure


    end

    % Data Storage
    properties (Access = private)
        filename = ""; % Filename of images
        roi = []; % Region of Interests
        img = []; % Image data
        gImg = []; % greyscale image data
        combImg = []; % combined image
        revImg = [];

        colourPcnt = 0; % Initial colour percentage
        sampleType = "Uniformed" 

        sigma1 = 100;
        sigma2 = 100;
        p = 1/2;
        delta = 2e-4;
        KernelFcn = "Gaussian";
        roundScheme = "MinMax";

        defaultKernel = 'Gaussian';
        defaultRound  = 'MinMax';
        defaultSigma1 = 100;
        defaultSigma2 = 100;
        defaultP      = 1/2;

        kernelPopup
        roundPopup
        sigma1Edit
        sigma2Edit
        pEdit

    end
    

    % Callback Functions
    methods (Access = private)

        % Button: Select and load an image
        function btnInputPushFcn(app, ~)
            [file, path] = uigetfile('*.*', 'Select an image');
            if isequal(file, 0)
                disp('User canceled file selection.');
                return;
            end
            app.filename = fullfile(path, file);

            % Clear all images in uiimage
            app.ImOG.ImageSource = "";
            app.ImRec.ImageSource = "";
            
            % Display the original image
            app.ImOrig.ImageSource = app.filename;
            app.img = imread(app.filename);

            % Generate and display grayscale image
            app.gImg = genGreyImg(app.filename);
            app.ImGrey.ImageSource = app.gImg;

        end

        % Button: Draw a region with colour
        % function btnDrawPushFcn(app, ~)
        %     if isempty(app.filename)
        %         disp('Please select an image');
        %         return;
        %     end
        %     % Create popup window
        %     app.PopFigure = uifigure('Name', 'Draw on Image', 'Position', [500, 300, 800, 600]);
        %     grid = uigridlayout(app.PopFigure, [2, 1]);
        %     grid.RowHeight = {'fit', '1x', 'fit'};
        % 
        %     % Create the label
        %     uilabel(grid, 'Text', 'Please draw on the image using your mouse', 'FontSize', 12, ...
        %         'HorizontalAlignment', 'center');
        % 
        %     % Create UI axes for displaying the image
        %     imgPanel = uipanel(grid);
        %     app.PopAxes = uiaxes(imgPanel);
        %     app.PopAxes.Position = [10, 10, 500, 500];
        % 
        %     % Button Panel
        %     buttonPanel = uigridlayout(grid, [1, 1]);
        %     % Button: Confirm and Close
        %     uibutton(buttonPanel, 'Text', 'Confirm and Close', 'ButtonPushedFcn', @(~, ~) app.confirmPopDrawing());
        % 
        %     % Load and display the image
        %     app.img = imread(app.filename);
        %     imshow(app.img, 'Parent', app.PopAxes);
        %     hold(app.PopAxes, 'on');
        % 
        %     app.roi = drawRegion(app.PopAxes, app.img);
        % end
        % 
        % % Confirm drawing, store ROI, and close popup
        % function confirmPopDrawing(app)
        %     close(app.PopFigure);
        %     combinedImg = combineMaskedImg(app.img, app.gImg, app.roi);
        %     app.ImOG.ImageSource = combinedImg;
        % end

        % Button: Select some pixels on the figure
        function btnSelectPixPushFcn(app, ~)
            if app.filename == ""
                errordlg('Please select an image');
                return;
            end
            % % Creat a popup window
            % app.PopFigure = uifigure('Name', 'Select Pixels on the Image', 'Position', [500, 300, 800, 600]);
            % grid = uigridlayout(app.PopFigure, [1, 1]);
            % grid.RowHeight = {'fit', '1x', 'fit'};
            % % title("Click on the pixel with the left mouse button on the image, and press Enter to end the selection.")
            % uilabel(grid, 'Text', "Click on the pixel with the left mouse button on the image, and press Enter to end the selection.",...
            %     'FontSize', 12, ...
            %      'HorizontalAlignment', 'center');
            % % Creat a panel to show the image
            % imgPanel = uipanel(grid);
            % app.PopSelectIm = uiimage(imgPanel);
            % app.PopSelectIm.ImageSource = app.img;
            % [x, y] = ginput;
            % disp(x)
            % disp(y)
            hFig = figure('Name','pixel selection',...
                  'NumberTitle','off',...
                  'MenuBar','none',...
                  'Toolbar','none',...
                  'Position',[300,200,800,600]);
            imshow(app.img, 'Parent', gca);
            [r, c] = ginput;
            r = uint8(r); c = uint8(c);

            [imgr, imgc, ~] = size(app.img);
            mask = zeros(imgr, imgc);
            mask(r, c) = 1;
            app.roi = mask;
            app.combImg = combineMaskedImg(app.img, app.gImg, app.roi);
            app.ImOG.ImageSource = app.combImg;
            close(hFig)      

        end

        % Radio button call back function
        function radioBtnFcn(app, event)
            selectedText = event.NewValue.Text;
            switch selectedText
                case "Uniformed"
                    app.TextField.Editable = 'on';
                    app.TextField.Enable = 'on';
                    app.sampleType = "Uniformed";
                    app.BtnAct.Text = "Generate";
                    
                case "Random"
                    app.TextField.Editable = 'on';
                    app.TextField.Enable = 'on';
                    app.sampleType = "Random";
                    app.BtnAct.Text = "Generate";

                % case "Draw"
                case "Select"
                    app.TextField.Editable = 'off';
                    app.TextField.Enable = 'off';
                    % app.sampleType = "Draw";
                    % app.BtnAct.Text = 'Draw';
                    app.sampleType = "Select";
                    app.BtnAct.Text = "Select";
            end

            disp(app.sampleType)
            
        end

        function textFieldFcn(app, event)
            app.colourPcnt = event.Value;
        end

        function btnGenROI(app)
            if app.filename == ""
                errordlg('Please select an image');
                return;
            end
            app.sampleType
            switch app.sampleType
                case "Uniformed"
                    app.roi = genUnif(app.img, app.colourPcnt);
                    app.combImg = combineMaskedImg(app.img, app.gImg, app.roi);
                    app.ImOG.ImageSource = app.combImg;
                    app.ImRec.ImageSource = "";
                case "Random"
                    app.roi = genRand(app.img, app.colourPcnt);
                    app.combImg = combineMaskedImg(app.img, app.gImg, app.roi);
                    app.ImOG.ImageSource = app.combImg;
                    app.ImRec.ImageSource = "";

                % case "Draw"
                %     btnDrawPushFcn(app)
                case "Select"
                    btnSelectPixPushFcn(app)
                    app.ImRec.ImageSource = "";
            end          
        end

        %% 
        % Button: Perform colourisation 
        function btnGenPushFcn(app, ~)
            if app.filename == ""
                errordlg('Please select an image first!')
            end
            app.revImg = imgRecBuildin(app.combImg, app.gImg, app.roi, ...
                app.sigma1, app.sigma2, app.p, app.delta, app.KernelFcn, app.roundScheme);
            app.ImRec.ImageSource = app.revImg;

        end

        % Button: Save the processed image
        function btnOutputPushFcn(app, ~)
            [file, path] = uiputfile({'*.png'; '*.jpg'; '*.bmp'}, 'Save Image As');
    
            if ischar(file)
                fullFileName = fullfile(path, file);
                imwrite(app.revImg, fullFileName); % Save recovered image
        
                % Popup a message box comfirming saving path
                msgbox(['Image saved to: ', fullFileName], 'Success');
            else
                errordlg('Save operation cancelled.'); % User cancel save operation
            end
        end

        
        function btnParSetPushFcn(app, ~)
    
            app.PopFigurePar = uifigure('Name', 'Settings', 'NumberTitle', 'off', ...
                'Position', [500, 400, 400, 250]);

    
            mainGrid = uigridlayout(app.PopFigurePar, [3, 1]);
            mainGrid.RowHeight = {'fit', 'fit', 'fit'};
            mainGrid.ColumnWidth = {'1x'};

            pChoose = uipanel(mainGrid, 'Title', 'Choose Kernel and Round Scheme');
            pChoose.Layout.Row = 1;

            chooseGrid = uigridlayout(pChoose, [2, 2]);
            chooseGrid.RowHeight = {'fit', 'fit'};
            chooseGrid.ColumnWidth = {'fit', '1x'};
            chooseGrid.Padding = [10 10 10 10];
            chooseGrid.RowSpacing = 5;
            chooseGrid.ColumnSpacing = 10;

            % Kernel Function
            uilabel(chooseGrid, 'Text', 'Kernel Function:', 'HorizontalAlignment', 'left');
            app.kernelPopup = uidropdown(chooseGrid, 'Items', {'Gaussian', 'CSRBF'}, ...
                'Value', app.KernelFcn);

            % Round Scheme
            uilabel(chooseGrid, 'Text', 'Round Scheme:', 'HorizontalAlignment', 'left');
            app.roundPopup = uidropdown(chooseGrid, 'Items', {'MinMax', 'Rescale'}, ...
                'Value', app.roundScheme);


            pParam = uipanel(mainGrid, 'Title', 'Parameter Settings');
            pParam.Layout.Row = 2;


            paramGrid = uigridlayout(pParam, [1, 6]);
            paramGrid.ColumnWidth = {'fit', '1x', 'fit', '1x', 'fit', '1x'};
            paramGrid.RowHeight = {'fit'};
            paramGrid.Padding = [10 10 10 10];
            paramGrid.ColumnSpacing = 10;

            % sigma1
            uilabel(paramGrid, 'Text', 'sigma1:', 'HorizontalAlignment', 'left');
            app.sigma1Edit = uieditfield(paramGrid, 'text', 'Value', num2str(app.sigma1));

            % sigma2
            uilabel(paramGrid, 'Text', 'sigma2:', 'HorizontalAlignment', 'left');
            app.sigma2Edit = uieditfield(paramGrid, 'text', 'Value', num2str(app.sigma2));

            % p
            uilabel(paramGrid, 'Text', 'p:', 'HorizontalAlignment', 'left');
            app.pEdit = uieditfield(paramGrid, 'text', 'Value', num2str(app.p));


            buttonGrid = uigridlayout(mainGrid, [1, 3]);
            buttonGrid.Layout.Row = 3;
            buttonGrid.ColumnWidth = {'1x', '1x', '1x'};
            buttonGrid.RowHeight = {'fit'};
            buttonGrid.ColumnSpacing = 10;
            buttonGrid.Padding = [10 10 10 10];

            % Confirm Button
            uibutton(buttonGrid, 'Text', 'Confirm', ...
                'ButtonPushedFcn', @(~, ~) app.confirmCallback());

            % Reset Button
            uibutton(buttonGrid, 'Text', 'Reset', ...
                'ButtonPushedFcn', @(~, ~) app.resetCallback());

            % Cancel Button
            uibutton(buttonGrid, 'Text', 'Cancel', ...
                'ButtonPushedFcn', @(~, ~) app.cancelCallback());
        end


        function confirmCallback(app, ~)

            app.KernelFcn = app.kernelPopup.Value;          
            % set(app.kernelPopup, 'Value', get(app.kernelPopup, 'Value'))

            app.roundScheme  = app.roundPopup.Value;
            % set(app.roundPopup, 'Value', get(app.roundPopup, 'Value'))

            app.sigma1 = str2double(app.sigma1Edit.Value);
            app.sigma2 = str2double(app.sigma2Edit.Value);
            app.p      = str2double(app.pEdit.Value);
            close(app.PopFigurePar); 
        end

        function resetCallback(app, ~)
            app.kernelPopup.Value = app.defaultKernel;
            app.roundPopup.Value = app.defaultRound;
            app.sigma1Edit.Value = num2str(app.defaultSigma1);
            app.sigma2Edit.Value = num2str(app.defaultSigma2);
            app.pEdit.Value = num2str(app.defaultP);
        end

        function cancelCallback(app, ~)
            close(app.PopFigurePar);
        end
        %%

    end


    % App Constructor
    methods (Access = public)

        function app = ImageColourisationApp()
            % Create main UI figure
            app.UIFigure = uifigure('Name', 'Image Colourisation', 'Position', [400, 240, 1000, 600]);

            % Create grid layout
            app.GridLayout = uigridlayout(app.UIFigure, [2, 3]);

            % right-side button panel
            app.ControlLayout = uigridlayout(app.GridLayout, [5, 1]);
            app.ControlLayout.Layout.Row = [1, 2];
            app.ControlLayout.Layout.Column = 3;

            % Create image windows
            app.ImOrig = uiimage(app.GridLayout);
            app.ImGrey = uiimage(app.GridLayout);
            app.ImOG = uiimage(app.GridLayout);
            app.ImRec = uiimage(app.GridLayout);

            % Set image window layout
            app.ImOrig.Layout.Row = 1;
            app.ImOrig.Layout.Column = 1;

            app.ImGrey.Layout.Row = 1;
            app.ImGrey.Layout.Column = 2;

            app.ImOG.Layout.Row = 2;
            app.ImOG.Layout.Column = 1;

            app.ImRec.Layout.Row = 2;
            app.ImRec.Layout.Column = 2;

            % Create buttons
            app.BtnInput = uibutton(app.ControlLayout, 'Text', 'Input an image', ...
                'ButtonPushedFcn', @(~, ~) app.btnInputPushFcn());
                 
            % 
            app.SelectPanel = uipanel(app.ControlLayout, 'Title', 'Select Colouring Type');
            app.SelectLayout = uigridlayout(app.SelectPanel, [2, 2]);
            app.BtnGroup = uibuttongroup("Parent", app.SelectLayout, 'SelectionChangedFcn', @(~, event) app.radioBtnFcn(event));
            app.BtnGroup.Layout.Row = 1;
            app.BtnGroup.Layout.Column = [1, 2];

            app.BtnUniformed = uiradiobutton(app.BtnGroup, "Text", 'Uniformed', 'Position', [10, 2, 91, 22]);
            app.BtnRandom = uiradiobutton(app.BtnGroup, "Text", 'Random', 'Position', [101, 2, 91, 22]);
            % app.BtnDraw = uiradiobutton(app.BtnGroup, "Text", 'Draw', 'Position', [192, 10, 91, 22]);
            app.BtnSelect = uiradiobutton(app.BtnGroup, "Text", 'Select', 'Position', [192, 2, 91, 22]);

            app.TextField = uieditfield(app.SelectLayout, 'numeric', 'Placeholder', ...
                '%', 'AllowEmpty','off', 'Limits', [0., 100.], 'RoundFractionalValues','off', ...
                'ValueChangedFcn', @(~, event) app.textFieldFcn(event));

            app.BtnAct = uibutton(app.SelectLayout, 'Text', 'Generate', 'ButtonPushedFcn', @(~, ~) app.btnGenROI());

            % TO DO
            app.BtnParSet = uibutton(app.ControlLayout, 'Text', 'Parameters & Methods', ...
                'ButtonPushedFcn', @(~, ~) app.btnParSetPushFcn());
            
            app.BtnGen = uibutton(app.ControlLayout, 'Text', 'Perform Colourisation', ...
                'ButtonPushedFcn', @(~, ~) app.btnGenPushFcn());

            app.BtnOutput = uibutton(app.ControlLayout, 'Text', 'Save Image', ...
                'ButtonPushedFcn', @(~, ~) app.btnOutputPushFcn());

            % Set button layout
            app.BtnInput.Layout.Row = 1;
            app.BtnParSet.Layout.Row = 3;
            app.BtnGen.Layout.Row = 4;
            app.BtnOutput.Layout.Row = 5;
        end
    end

end
