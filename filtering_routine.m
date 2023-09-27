% To run in the server, you should find runica.m line in which you have the
% message ...interrupt runica... and turn the property visible to off 

eeglab nogui;
file_source = '';
file_destination = '';
dir_source = '/home/paulo/Documents/curso_de_inverno_coleta/eeglab_current/eeglab2023.0/sample_data/';
dir_destination = '/home/paulo/Documents/temporary/performing_a_test/';
% Opening the dataset
EEG = pop_loadset('filename','eeglab_data.set','filepath', file_source);
[~, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0 );
fc = 1; fs = EEG.srate;
[b,a] = butter(4,fc/(fs/2), 'high');

for k = 1:size(EEG.data,1)
    EEG.data(k,:) = filtfilt(b,a, double(EEG.data(k,:)) );
    fprintf('Filtering channel %d of %d. \n', k, size(EEG.data,1));
end
ALLEEG.data = EEG.data;

% Run ICA in the EEG data
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1, 'chanind', [1:32]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
% Run ICLabel in data
EEG = pop_iclabel(EEG, 'default');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
% Save data
EEG = pop_saveset( EEG, 'filename','pos_iclabel_dataset.set','filepath', file_destination);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

