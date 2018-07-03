function init_rc_fig(app)

app.rc_fig = figure('Position', [1544 542 506 505], ...
	'NumberTitle', 'off', 'Name', 'Recruitment Curve', ...
	'MenuBar', 'none', 'ToolBar', 'none');


app.rc_axes = axes('Position', [0.16 0.3 0.775 0.6], ...
	'Fontsize', 20);
ylabel('MEP Vp-p (�V)')
xlabel('Magstim Power')

% userdata is a table with the data
app.rc_axes.UserData = cell2table(cell(0,4), ...
	'VariableNames', {'Epoch', 'Use', 'MagStim_Setting', 'MEPAmpl_uVPp'});

% button to compute curve fit
h = uicontrol(app.rc_fig, 'Style', 'pushbutton', ...
			'String', 'Compute Curve Fit', ...
			'Units', 'normalized', ...
			'Position', [0.35 0.019 0.4 0.06], ...
			'Fontsize', 16, ...
			'Callback', {@rc_boltzman_fit, app});

% button to save datapoints
h_save = uicontrol(app.rc_fig, 'Style', 'pushbutton', ...
			'String', 'Save', ...
			'Units', 'normalized', ...
			'Position', [0.75 0.019 0.2 0.06], ...
			'Fontsize', 16, ...
			'Tag', 'pushbutton', ...
			'Callback', {@save_and_close_rc, app});

% set a close function to save the data
app.rc_fig.CloseRequestFcn = {@save_and_close_rc, app};
% 
% % labels
uicontrol(app.rc_fig, ...
	'Style', 'text', ...
	'String', 'Norm Factor', ...
	'Units', 'normalized', ...
	'Position', [0.04 0.2 0.149 0.04], ...
	'FontSize', 12);
uicontrol(app.rc_fig, ...
	'Style', 'text', ...
	'String', 'Slope, m', ...
	'Units', 'normalized', ...
	'Position', [0.173 0.14 0.149 0.04], ...
	'FontSize', 12);
uicontrol(app.rc_fig, ...
	'Style', 'text', ...
	'String', 'S_50', ...
	'Units', 'normalized', ...
	'Position', [0.415 0.14 0.094 0.04], ...
	'FontSize', 12);
uicontrol(app.rc_fig, ...
	'Style', 'text', ...
	'String', 'MEP_max', ...
	'Units', 'normalized', ...
	'Position', [0.597 0.14 0.141 0.04], ...
	'FontSize', 12);
% uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', 'Initial', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.038 0.196 0.094 0.027]);
% uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', 'Fit', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.036 0.143 0.107 0.027]);
% uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', 'Confidence', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.0 0.104 0.172 0.027]);
% uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', 'Interval', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.011 0.085 0.147 0.027]);
% 
% 
% fitting input parameters
app.rc_fit_ui.edNormFactor = uicontrol(app.rc_fig, ...
	'Style', 'edit', ...
	'String', '1.0', ...
	'Units', 'normalized', ...
	'Position', [0.05 0.17 0.122 0.032], ...
	'FontSize', 12, ...
	'Callback', {@rc_change_norm_factor, app});
app.rc_fit_ui.edSlope = uicontrol(app.rc_fig, ...
	'Style', 'edit', ...
	'String', '0.1', ...
	'Units', 'normalized', ...
	'Position', [0.187 0.115 0.122 0.032], ...
	'FontSize', 12);
app.rc_fit_ui.edS50 = uicontrol(app.rc_fig, ...
	'Style', 'edit', ...
	'String', '50', ...
	'Units', 'normalized', ...
	'Position', [0.398 0.115 0.122 0.032], ...
	'FontSize', 12);
app.rc_fit_ui.edMEPmax = uicontrol(app.rc_fig, ...
	'Style', 'edit', ...
	'String', '500', ...
	'Units', 'normalized', ...
	'Position', [0.604 0.115 0.122 0.032], ...
	'FontSize', 12);
% 
% % fitting output parameters
% app.rc_fit_ui.txtSlope = uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', '', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.199 0.143 0.107 0.027]);
% app.rc_fit_ui.txtS50 = uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', '', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.413 0.143 0.107 0.027]);
% app.rc_fit_ui.txtMEPmax = uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', '', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.609 0.143 0.107 0.027]);
% 
% app.rc_fit_ui.txtSlopeCI1 = uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', '[x, ', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.165 0.112 0.172 0.027]);
% app.rc_fit_ui.txtSlopeCI2 = uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', 'x]', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.165 0.085 0.172 0.027]);

app.rc_fit_ui.txtSlopeCI = uicontrol(app.rc_fig, ...
	'Style', 'text', ...
	'String', '[x, x]', ...
	'Units', 'normalized', ...
	'Position', [0.165 0.085 0.172 0.027]);


% app.rc_fit_ui.txtS50CI1 = uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', '[x, ', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.379 0.112 0.172 0.027]);
% app.rc_fit_ui.txtS50CI2 = uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', 'x]', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.379 0.085 0.172 0.027]);
app.rc_fit_ui.txtS50CI = uicontrol(app.rc_fig, ...
	'Style', 'text', ...
	'String', '[x, x]', ...
	'Units', 'normalized', ...
	'Position', [0.379 0.085 0.172 0.027]);

% app.rc_fit_ui.txtMEPmaxCI1 = uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', '[x, ', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.576 0.112 0.172 0.027]);
% app.rc_fit_ui.txtMEPmaxCI2 = uicontrol(app.rc_fig, ...
% 	'Style', 'text', ...
% 	'String', 'x]', ...
% 	'Units', 'normalized', ...
% 	'Position', [0.576 0.085 0.172 0.027]);
app.rc_fit_ui.txtMEPmaxCI = uicontrol(app.rc_fig, ...
	'Style', 'text', ...
	'String', '[x, x]', ...
	'Units', 'normalized', ...
	'Position', [0.576 0.085 0.172 0.027]);

app.rc_fit_ui.txtRsq = uicontrol(app.rc_fig, ...
	'Style', 'text', ...
	'String', 'Rsq = 0.0', ...
	'Units', 'normalized', ...
	'Position', [0.767 0.1 0.2 0.07], ...
	'FontSize', 15);

app.rc_fit_ui.txtAUC = uicontrol(app.rc_fig, ...
	'Style', 'text', ...
	'String', 'AUC = 0.0', ...
	'Units', 'normalized', ...
	'Position', [0.767 0.085 0.229 0.027]);




