function init_sici_fig(app)

% if there is already a sici fig, clear old axes & fit info
if ~isempty(findobj('Name', 'SICI & ICF'))
	app.sici_axes;
	
	% clear any existing fit_info
	app.sici_info = [];
	% reset ui
	ylabel('MEP Vp-p (�V)')
	app.sici_info.edNormFactor.String = '1';
	app.sici_info.edSlope.String = '0.1';
	app.sici_info.edS50.String = '50';
	app.sici_info.edMEPmax.String = '';
	app.sici_info.txtSlopeCI.String = '[x, x]';
	app.sici_info.txtS50CI.String = '[x, x]';
	app.sici_info.txtMEPmaxCI.String = '[x, x]';
	app.sici_info.txtRsq.String = 'Rsq = 0.0';
	app.sici_info.txtAUC.String = 'AUC = 0.0';
	
else

	app.sici_fig = figure('Position', [1544 542 506 505], ...
		'NumberTitle', 'off', 'Name', 'SICI & ICF', ...
		'MenuBar', 'none', 'ToolBar', 'none');


	app.sici_axes = axes('Position', [0.16 0.3 0.775 0.6], ...
		'Fontsize', 20);
	ylabel('MEP Vp-p (�V)')
	xlabel('Sample Number')

	% userdata is a table with the data
	app.sici_axes.UserData = cell2table(cell(0,4), ...
		'VariableNames', {'Epoch', 'Use', 'MagStim_Setting', 'MEPAmpl_uVPp'});

	% button to compute curve fit
	h = uicontrol(app.sici_fig, 'Style', 'pushbutton', ...
				'String', 'Compute Curve Fit', ...
				'Units', 'normalized', ...
				'Position', [0.35 0.019 0.4 0.06], ...
				'Fontsize', 16, ...
				'Callback', {@sici_mean, app});

	% button to save datapoints
	h_save = uicontrol(app.sici_fig, 'Style', 'pushbutton', ...
				'String', 'Save', ...
				'Units', 'normalized', ...
				'Position', [0.75 0.019 0.2 0.06], ...
				'Fontsize', 16, ...
				'Tag', 'pushbutton', ...
				'Callback', {@save_and_close_sici, app});

	% button to print as png
	h_print = uicontrol(app.sici_fig, 'Style', 'pushbutton', ...
				'String', 'P', ...
				'Units', 'normalized', ...
				'Position', [0.95 0.03 0.04 0.04], ...
				'Fontsize', 8, ...
				'Callback', {@print_sici, app});
	
	
	% set a close function to save the data
	app.sici_fig.CloseRequestFcn = {@save_and_close_sici, app};

	%{
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
	uicontrol(app.rc_fig, ...
		'Style', 'text', ...
		'String', 'RC Min', ...
		'Units', 'normalized', ...
		'Position', [0.04 0.14 0.149 0.04], ...
		'FontSize', 12);
	uicontrol(app.rc_fig, ...
		'Style', 'text', ...
		'String', 'MEP Val', ...
		'Units', 'normalized', ...
		'Position', [0.04 0.05 0.149 0.04], ...
		'FontSize', 12);
	uicontrol(app.rc_fig, ...
		'Style', 'text', ...
		'String', 'Stim Val', ...
		'Units', 'normalized', ...
		'Position', [0.173 0.05 0.149 0.04], ...
		'FontSize', 12);

	% fitting input parameters
	app.sici_info.edNormFactor = uicontrol(app.rc_fig, ...
		'Style', 'edit', ...
		'String', '1.0', ...
		'Units', 'normalized', ...
		'Position', [0.05 0.17 0.122 0.032], ...
		'FontSize', 12, ...
		'Callback', {@rc_change_norm_factor, app});
	app.sici_info.edSlope = uicontrol(app.rc_fig, ...
		'Style', 'edit', ...
		'String', '0.1', ...
		'Units', 'normalized', ...
		'Position', [0.187 0.115 0.122 0.032], ...
		'FontSize', 12);
	app.sici_info.edS50 = uicontrol(app.rc_fig, ...
		'Style', 'edit', ...
		'String', '50', ...
		'Units', 'normalized', ...
		'Position', [0.398 0.115 0.122 0.032], ...
		'FontSize', 12);
	app.sici_info.edMEPmax = uicontrol(app.rc_fig, ...
		'Style', 'edit', ...
		'String', '', ...
		'Units', 'normalized', ...
		'Position', [0.604 0.115 0.122 0.032], ...
		'FontSize', 12);
	
	app.sici_info.edMEPmin = uicontrol(app.rc_fig, ...
		'Style', 'edit', ...
		'String', '', ...
		'Units', 'normalized', ...
		'Position', [0.04 0.115 0.122 0.032], ...
		'FontSize', 12);
	
	app.sici_info.edMEPval = uicontrol(app.rc_fig, ...
		'Style', 'edit', ...
		'String', '', ...
		'Units', 'normalized', ...
		'Position', [0.04 0.03 0.122 0.032], ...
		'FontSize', 12, ...
		'Callback', {@rc_change_mep_val, app});
	
	app.sici_info.editStimval = uicontrol(app.rc_fig, ...
		'Style', 'edit', ...
		'String', '', ...
		'Units', 'normalized', ...
		'Position', [0.187 0.03 0.122 0.032], ...
		'FontSize', 12, ...
		'Callback', {@rc_change_stim_val, app});
	

	app.sici_info.txtSlopeCI = uicontrol(app.rc_fig, ...
		'Style', 'text', ...
		'String', '[x, x]', ...
		'Units', 'normalized', ...
		'Position', [0.165 0.085 0.172 0.027]);


	app.sici_info.txtS50CI = uicontrol(app.rc_fig, ...
		'Style', 'text', ...
		'String', '[x, x]', ...
		'Units', 'normalized', ...
		'Position', [0.379 0.085 0.172 0.027]);

	
	app.sici_info.txtMEPmaxCI = uicontrol(app.rc_fig, ...
		'Style', 'text', ...
		'String', '[x, x]', ...
		'Units', 'normalized', ...
		'Position', [0.576 0.085 0.172 0.027]);

	app.sici_info.txtRsq = uicontrol(app.rc_fig, ...
		'Style', 'text', ...
		'String', 'Rsq = 0.0', ...
		'Units', 'normalized', ...
		'Position', [0.767 0.1 0.2 0.07], ...
		'FontSize', 15);

	app.sici_info.txtAUC = uicontrol(app.rc_fig, ...
		'Style', 'text', ...
		'String', 'AUC = 0.0', ...
		'Units', 'normalized', ...
		'Position', [0.767 0.085 0.229 0.027]);
	%}
end

