function print_rc(source, event, app)

if ~any(strcmp(properties(app), 'SaveLocationEditField')) 
	save_loc = pwd;
	fname_prefix = '';
else
	if isempty(app.SaveLocationEditField.Value)
		app.SaveLocationEditField.Value = pwd;
		save_loc = pwd;
	else
		save_loc = app.SaveLocationEditField.Value;
	end
	fname_prefix = app.EditFieldFilenameprefix.Value;
end


set(app.rc_fig,'PaperOrientation', orient, ...
	'PaperUnits','inches', ...
	'PaperPosition', [0 0 7 8]);

% 	'PaperSize', [6 7], ..
fname = [save_loc '/' fname_prefix strrep(app.rc_axes.Title.String, ' ', '_') '_rc_not_norm.png'];

% if norm value > 1, change not_norm to norm in fitinfo_fname
if str2double(app.rc_fit_ui.edNormFactor.String) > 1
	fname = strrep(fname, '_not_norm', '_norm');
end


print(app.rc_fig, '-dpng', fname);
