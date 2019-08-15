class BackupSettings {
  final bool promptOnError;

  BackupSettings(this.promptOnError);
  BackupSettings.fromJson(Map<String, dynamic> json) : this(json["promptOnError"] ?? false);

  BackupSettings.start() : this(true);

  BackupSettings copyWith({bool promptOnError}) {
    return BackupSettings(promptOnError ?? this.promptOnError);
  }
  Map<String, dynamic> toJson(){
    return {"promptOnError": promptOnError};
  }
}

class BackupState {
  final DateTime lastBackupTime;
  final bool inProgress;

  BackupState(this.lastBackupTime, this.inProgress);
}