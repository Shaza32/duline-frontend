enum AppLang {
  en,
  de,
  ar,
  fr,
  es,
  it,
  tr,
  ru,
}

class AppStrings {
  // ===== Core =====
  final String appTitle;
  final String setupTitle;
  final String setupHint;
  final String addMemberLabel;
  final String noMembersYet;
  final String finishSetupButton;
  final String currentUserLabel;

  // ===== Tasks =====
  final String newTaskPlaceholder;
  final String noTasksYet;
  final String addedBy;
  final String createdAt;
  final String taskFree;
  final String taskTakenBy;
  final String takeTask;
  final String releaseTask;
  final String reservedTask;

  // ===== Profile (من شاشتك) =====
  final String noName;
  final String noEmail;
  final String settingsTitle;
  final String languageTitle;
  final String chooseLanguageTitle;
  final String close;
  final String logout;

  // ===== Auth: common =====
  final String emailAddressLabel;
  final String emailRequired;
  final String emailInvalid;

  final String passwordLabel;
  final String requiredField;

  // ===== Login =====
  final String signInBtn;
  final String forgotPassword;
  final String noAccount;
  final String createNest;
  final String loginInvalidCredentials;

  // ===== Forgot password =====
  final String forgotPasswordHint;
  final String sendCodeBtn;
  final String failedToSendCode;

  // ===== Verify code =====
  final String verifyCodeTitle;
  final String codeLabel;
  final String codeRequired;
  final String codeMustBe6Digits;
  final String verifyBtn;
  final String invalidOrExpiredCode;

  // ===== Reset password =====
  final String setNewPasswordTitle;
  final String newPasswordLabel;
  final String passwordRequired;
  final String passwordMin6;
  final String confirmPasswordLabel;
  final String confirmRequired;
  final String passwordsDoNotMatch;
  final String resetPasswordBtn;
  final String resetFailedSessionExpired;
  final String passwordChangedSuccessfully;
  final String passwordChangedSuccess;
  final String resetFailedExpired;
  final String resetPasswordTitle;
  // ===== Register =====
  final String nameLabel;
  final String nameRequired;
  final String passwordMinChars;

  final String familySectionTitle;
  final String familyCodeOptionalLabel;
  final String familyCodeHint;
  final String orLabel;
  final String familyNameOptionalLabel;
  final String familyNameHint;

  final String createAccountBtn;
  final String chooseOnlyOneFamilyCodeOrName;
  final String registerFailedPrefix;
  // Verify code
  final String verifyCodeHint;
  // group List screen
  final String showInviteCode;
  final String copyCode;
  final String shareCode;
  final String codeCopied;
  final String shareInviteTemplate;
  final String inviteCodeTitle;
  final String copyBtn;
  final String closeBtn;
  final String roleLabel;
  final String groupsEmptyHint;
  // group tasks
  final String pleaseLoginAgain;
  final String groupDefaultTitle;
  final String addBtn;
  final String errorPrefix;
  final String duePrefix;
  final String doneBtn;
  final String taskOverdue;
  final String taskDueSoon;

// main shell
  final String titleMyGroups;
  final String titleTasks;
  final String titleProfile;

  final String addGroupTitle;
  final String joinByCodeTitle;
  final String createNewGroupTitle;

  final String enterInviteCode;
  final String inviteCodeHint;
  final String enterGroupName;
  final String groupNameHint;

  final String joinBtn;
  final String createBtn;

  final String joinedSuccessfully;
  final String createdSuccessfully;

  final String joinFailedPrefix;
  final String createFailedPrefix;

  final String chooseGroupFirst;
  final String unknownUserInitial;

  final String navGroups;
  final String navTasks;
  final String navProfile;
// personal info
  final String nameUpdated;
  final String passwordChanged;
  final String backendDidNotReturnAvatarUrl;
  final String photoUpdated;
  final String accountDeleted;
  final String errorDeletingAccount;
  final String deleteAccountDialogTitle;
  final String deleteAccountDialogBody;

  final String cancelBtn;
  final String deleteBtn;
  final String deleteAccountBtn;
  final String saveNameBtn;
  final String updatePasswordBtn;
  final String uploading;
  final String deleting;
  final String personalInfoTitle;
  final String nameSectionTitle;
  final String changePasswordSectionTitle;
  final String dangerZoneTitle;

  final String yourNameLabel;
  final String emailLabel;
  final String oldPasswordLabel;
  final String changePhoto;
  final String deletePermanentHint;
//  Profile


  final String langEnglish;
  final String langGerman;
  final String langArabic;
  final String sessionExpiredPleaseRelogin;
  final String nameRequiredSaveFirst;


  final String byHaski;
  // ===== My Tasks screen =====
  final String myTasks;

  // ===== Navbar =====
  final String home;
  final String addFamilyMembers;
  final String profile;

  const AppStrings({
    // Core
    required this.appTitle,
    required this.setupTitle,
    required this.setupHint,
    required this.addMemberLabel,
    required this.noMembersYet,
    required this.finishSetupButton,
    required this.currentUserLabel,

    // Tasks
    required this.newTaskPlaceholder,
    required this.noTasksYet,
    required this.addedBy,
    required this.createdAt,
    required this.taskFree,
    required this.taskTakenBy,
    required this.takeTask,
    required this.releaseTask,
    required this.reservedTask,

    // Profile
    required this.noName,
    required this.noEmail,
    required this.settingsTitle,
    required this.languageTitle,
    required this.chooseLanguageTitle,
    required this.close,
    required this.logout,
    required this.sessionExpiredPleaseRelogin,
    required this.nameRequiredSaveFirst,


    // Auth common
    required this.emailAddressLabel,
    required this.emailRequired,
    required this.emailInvalid,
    required this.passwordLabel,
    required this.requiredField,

    // Login
    required this.signInBtn,
    required this.forgotPassword,
    required this.noAccount,
    required this.createNest,
    required this.loginInvalidCredentials,

    // Forgot password
    required this.forgotPasswordHint,
    required this.sendCodeBtn,
    required this.failedToSendCode,

    // Verify code
    required this.verifyCodeTitle,
    required this.codeLabel,
    required this.codeRequired,
    required this.codeMustBe6Digits,
    required this.verifyBtn,
    required this.invalidOrExpiredCode,
    required this.verifyCodeHint,
    // Navbar
    required this.home,
    required this.addFamilyMembers,
    required this.profile,

    // Reset password
    required this.setNewPasswordTitle,
    required this.newPasswordLabel,
    required this.passwordRequired,
    required this.passwordMin6,
    required this.confirmPasswordLabel,
    required this.confirmRequired,
    required this.passwordsDoNotMatch,
    required this.resetPasswordBtn,
    required this.resetFailedSessionExpired,
    required this.passwordChangedSuccessfully,
    required this.passwordChangedSuccess,
    required this.resetFailedExpired,
    required this.resetPasswordTitle,
    // Register
    required this.nameLabel,
    required this.nameRequired,
    required this.passwordMinChars,
    required this.familySectionTitle,
    required this.familyCodeOptionalLabel,
    required this.familyCodeHint,
    required this.orLabel,
    required this.familyNameOptionalLabel,
    required this.familyNameHint,
    required this.createAccountBtn,
    required this.chooseOnlyOneFamilyCodeOrName,
    required this.registerFailedPrefix,
    // group List screen
    required this.showInviteCode,
    required this.copyCode,
    required this.shareCode,
    required this.codeCopied,
    required this.shareInviteTemplate,
    required this.inviteCodeTitle,
    required this.copyBtn,
    required this.closeBtn,
    required this.groupsEmptyHint,
    required this.roleLabel,
    // group tasks
    required this.pleaseLoginAgain,
    required this.groupDefaultTitle,
    required this.addBtn,
    required this.errorPrefix,
    required this.duePrefix,
    required this.doneBtn,
    required this.taskOverdue,
    required this.taskDueSoon,

    // main shell
    required this.titleMyGroups,
    required this.titleTasks,
    required this.titleProfile,

    required this.addGroupTitle,
    required this.joinByCodeTitle,
    required this.createNewGroupTitle,

    required this.enterInviteCode,
    required this.inviteCodeHint,
    required this.enterGroupName,
    required this.groupNameHint,

    required this.joinBtn,
    required this.createBtn,

    required this.joinedSuccessfully,
    required this.createdSuccessfully,

    required this.joinFailedPrefix,
    required this.createFailedPrefix,

    required this.chooseGroupFirst,
    required this.unknownUserInitial,

    required this.navGroups,
    required this.navTasks,
    required this.navProfile,
    // personal info
    required this.nameUpdated,
    required this.passwordChanged,
    required this.backendDidNotReturnAvatarUrl,
    required this.photoUpdated,
    required this.accountDeleted,
    required this.errorDeletingAccount,
    required this.deleteAccountDialogTitle,
    required this.deleteAccountDialogBody,

    required this.cancelBtn,
    required this.deleteBtn,
    required this.deleteAccountBtn,
    required this.saveNameBtn,
    required this.updatePasswordBtn,
    required this.uploading,
    required this.deleting,
    required this.personalInfoTitle,
    required this.nameSectionTitle,
    required this.changePasswordSectionTitle,
    required this.dangerZoneTitle,

    required this.yourNameLabel,
    required this.emailLabel,
    required this.oldPasswordLabel,
    required this.changePhoto,
    required this.deletePermanentHint,
//  Profile

    required this.langEnglish,
    required this.langGerman,
    required this.langArabic,
    required this.byHaski,
    // ===== My Tasks screen =====
    required this.myTasks,
  });
  AppStrings copyWith({
    String? appTitle,
    String? setupTitle,
    String? setupHint,
    String? addMemberLabel,
    String? noMembersYet,
    String? finishSetupButton,
    String? currentUserLabel,
    String? newTaskPlaceholder,
    String? noTasksYet,
    String? addedBy,
    String? home,
    String? addFamilyMembers,
    String? profile,
    String? createdAt,
    String? taskFree,
    String? taskTakenBy,
    String? takeTask,
    String? releaseTask,
    String? reservedTask,
    String? noName,
    String? noEmail,
    String? settingsTitle,
    String? languageTitle,
    String? chooseLanguageTitle,
    String? close,
    String? logout,
    String? emailAddressLabel,
    String? emailRequired,
    String? emailInvalid,
    String? passwordLabel,
    String? requiredField,
    String? signInBtn,
    String? forgotPassword,
    String? noAccount,
    String? createNest,
    String? loginInvalidCredentials,
    String? forgotPasswordHint,
    String? sendCodeBtn,
    String? failedToSendCode,
    String? verifyCodeTitle,
    String? codeLabel,
    String? codeRequired,
    String? codeMustBe6Digits,
    String? verifyBtn,
    String? invalidOrExpiredCode,
    String? setNewPasswordTitle,
    String? newPasswordLabel,
    String? passwordRequired,
    String? passwordMin6,
    String? confirmPasswordLabel,
    String? confirmRequired,
    String? passwordsDoNotMatch,
    String? resetPasswordBtn,
    String? resetFailedSessionExpired,
    String? passwordChangedSuccessfully,
    String? passwordChangedSuccess,
    String? resetFailedExpired,
    String? resetPasswordTitle,
    String? nameLabel,
    String? nameRequired,
    String? passwordMinChars,
    String? familySectionTitle,
    String? familyCodeOptionalLabel,
    String? familyCodeHint,
    String? orLabel,
    String? familyNameOptionalLabel,
    String? familyNameHint,
    String? createAccountBtn,
    String? chooseOnlyOneFamilyCodeOrName,
    String? registerFailedPrefix,
    String? verifyCodeHint,
    String? showInviteCode,
    String? copyCode,
    String? shareCode,
    String? codeCopied,
    String? shareInviteTemplate,
    String? inviteCodeTitle,
    String? copyBtn,
    String? closeBtn,
    String? roleLabel,
    String? groupsEmptyHint,
    String? pleaseLoginAgain,
    String? groupDefaultTitle,
    String? addBtn,
    String? errorPrefix,
    String? duePrefix,
    String? doneBtn,
    String? taskOverdue,
    String? taskDueSoon,
    String? titleMyGroups,
    String? titleTasks,
    String? titleProfile,
    String? addGroupTitle,
    String? joinByCodeTitle,
    String? createNewGroupTitle,
    String? enterInviteCode,
    String? inviteCodeHint,
    String? enterGroupName,
    String? groupNameHint,
    String? joinBtn,
    String? createBtn,
    String? joinedSuccessfully,
    String? createdSuccessfully,
    String? joinFailedPrefix,
    String? createFailedPrefix,
    String? chooseGroupFirst,
    String? unknownUserInitial,
    String? navGroups,
    String? navTasks,
    String? navProfile,
    String? nameUpdated,
    String? passwordChanged,
    String? backendDidNotReturnAvatarUrl,
    String? photoUpdated,
    String? accountDeleted,
    String? errorDeletingAccount,
    String? deleteAccountDialogTitle,
    String? deleteAccountDialogBody,
    String? cancelBtn,
    String? deleteBtn,
    String? deleteAccountBtn,
    String? saveNameBtn,
    String? updatePasswordBtn,
    String? uploading,
    String? deleting,
    String? personalInfoTitle,
    String? nameSectionTitle,
    String? changePasswordSectionTitle,
    String? dangerZoneTitle,
    String? yourNameLabel,
    String? emailLabel,
    String? oldPasswordLabel,
    String? changePhoto,
    String? deletePermanentHint,
    String? langEnglish,
    String? langGerman,
    String? langArabic,
    String? byHaski,
    String? myTasks,
    String? sessionExpiredPleaseRelogin,
    String? nameRequiredSaveFirst,

  }) {
    return AppStrings(
      appTitle: appTitle ?? this.appTitle,
      setupTitle: setupTitle ?? this.setupTitle,
      setupHint: setupHint ?? this.setupHint,
      addMemberLabel: addMemberLabel ?? this.addMemberLabel,
      noMembersYet: noMembersYet ?? this.noMembersYet,
      finishSetupButton: finishSetupButton ?? this.finishSetupButton,
      currentUserLabel: currentUserLabel ?? this.currentUserLabel,
      newTaskPlaceholder: newTaskPlaceholder ?? this.newTaskPlaceholder,
      noTasksYet: noTasksYet ?? this.noTasksYet,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
      taskFree: taskFree ?? this.taskFree,
      taskTakenBy: taskTakenBy ?? this.taskTakenBy,
      takeTask: takeTask ?? this.takeTask,
      releaseTask: releaseTask ?? this.releaseTask,
      reservedTask: reservedTask ?? this.reservedTask,
      noName: noName ?? this.noName,
      noEmail: noEmail ?? this.noEmail,
      settingsTitle: settingsTitle ?? this.settingsTitle,
      languageTitle: languageTitle ?? this.languageTitle,
      chooseLanguageTitle: chooseLanguageTitle ?? this.chooseLanguageTitle,
      close: close ?? this.close,
      logout: logout ?? this.logout,
      emailAddressLabel: emailAddressLabel ?? this.emailAddressLabel,
      emailRequired: emailRequired ?? this.emailRequired,
      emailInvalid: emailInvalid ?? this.emailInvalid,
      passwordLabel: passwordLabel ?? this.passwordLabel,
      requiredField: requiredField ?? this.requiredField,
      signInBtn: signInBtn ?? this.signInBtn,
      forgotPassword: forgotPassword ?? this.forgotPassword,
      noAccount: noAccount ?? this.noAccount,
      createNest: createNest ?? this.createNest,
      loginInvalidCredentials: loginInvalidCredentials ?? this.loginInvalidCredentials,
      forgotPasswordHint: forgotPasswordHint ?? this.forgotPasswordHint,
      sendCodeBtn: sendCodeBtn ?? this.sendCodeBtn,
      failedToSendCode: failedToSendCode ?? this.failedToSendCode,
      verifyCodeTitle: verifyCodeTitle ?? this.verifyCodeTitle,
      codeLabel: codeLabel ?? this.codeLabel,
      codeRequired: codeRequired ?? this.codeRequired,
      codeMustBe6Digits: codeMustBe6Digits ?? this.codeMustBe6Digits,
      verifyBtn: verifyBtn ?? this.verifyBtn,
      invalidOrExpiredCode: invalidOrExpiredCode ?? this.invalidOrExpiredCode,
      setNewPasswordTitle: setNewPasswordTitle ?? this.setNewPasswordTitle,
      newPasswordLabel: newPasswordLabel ?? this.newPasswordLabel,
      passwordRequired: passwordRequired ?? this.passwordRequired,
      passwordMin6: passwordMin6 ?? this.passwordMin6,
      confirmPasswordLabel: confirmPasswordLabel ?? this.confirmPasswordLabel,
      confirmRequired: confirmRequired ?? this.confirmRequired,
      passwordsDoNotMatch: passwordsDoNotMatch ?? this.passwordsDoNotMatch,
      resetPasswordBtn: resetPasswordBtn ?? this.resetPasswordBtn,
      resetFailedSessionExpired: resetFailedSessionExpired ?? this.resetFailedSessionExpired,
      passwordChangedSuccessfully: passwordChangedSuccessfully ?? this.passwordChangedSuccessfully,
      passwordChangedSuccess: passwordChangedSuccess ?? this.passwordChangedSuccess,
      resetFailedExpired: resetFailedExpired ?? this.resetFailedExpired,
      resetPasswordTitle: resetPasswordTitle ?? this.resetPasswordTitle,
      nameLabel: nameLabel ?? this.nameLabel,
      nameRequired: nameRequired ?? this.nameRequired,
      passwordMinChars: passwordMinChars ?? this.passwordMinChars,
      familySectionTitle: familySectionTitle ?? this.familySectionTitle,
      familyCodeOptionalLabel: familyCodeOptionalLabel ?? this.familyCodeOptionalLabel,
      familyCodeHint: familyCodeHint ?? this.familyCodeHint,
      orLabel: orLabel ?? this.orLabel,
      familyNameOptionalLabel: familyNameOptionalLabel ?? this.familyNameOptionalLabel,
      familyNameHint: familyNameHint ?? this.familyNameHint,
      createAccountBtn: createAccountBtn ?? this.createAccountBtn,
      chooseOnlyOneFamilyCodeOrName: chooseOnlyOneFamilyCodeOrName ?? this.chooseOnlyOneFamilyCodeOrName,
      registerFailedPrefix: registerFailedPrefix ?? this.registerFailedPrefix,
      verifyCodeHint: verifyCodeHint ?? this.verifyCodeHint,
      showInviteCode: showInviteCode ?? this.showInviteCode,
      copyCode: copyCode ?? this.copyCode,
      shareCode: shareCode ?? this.shareCode,
      codeCopied: codeCopied ?? this.codeCopied,
      shareInviteTemplate: shareInviteTemplate ?? this.shareInviteTemplate,
      inviteCodeTitle: inviteCodeTitle ?? this.inviteCodeTitle,
      copyBtn: copyBtn ?? this.copyBtn,
      closeBtn: closeBtn ?? this.closeBtn,
      roleLabel: roleLabel ?? this.roleLabel,
      groupsEmptyHint: groupsEmptyHint ?? this.groupsEmptyHint,
      pleaseLoginAgain: pleaseLoginAgain ?? this.pleaseLoginAgain,
      groupDefaultTitle: groupDefaultTitle ?? this.groupDefaultTitle,
      addBtn: addBtn ?? this.addBtn,
      errorPrefix: errorPrefix ?? this.errorPrefix,
      duePrefix: duePrefix ?? this.duePrefix,
      doneBtn: doneBtn ?? this.doneBtn,
      taskOverdue: taskOverdue ?? this.taskOverdue,
      taskDueSoon: taskDueSoon ?? this.taskDueSoon,
      titleMyGroups: titleMyGroups ?? this.titleMyGroups,
      titleTasks: titleTasks ?? this.titleTasks,
      titleProfile: titleProfile ?? this.titleProfile,
      addGroupTitle: addGroupTitle ?? this.addGroupTitle,
      joinByCodeTitle: joinByCodeTitle ?? this.joinByCodeTitle,
      createNewGroupTitle: createNewGroupTitle ?? this.createNewGroupTitle,
      enterInviteCode: enterInviteCode ?? this.enterInviteCode,
      inviteCodeHint: inviteCodeHint ?? this.inviteCodeHint,
      enterGroupName: enterGroupName ?? this.enterGroupName,
      groupNameHint: groupNameHint ?? this.groupNameHint,
      joinBtn: joinBtn ?? this.joinBtn,
      createBtn: createBtn ?? this.createBtn,
      joinedSuccessfully: joinedSuccessfully ?? this.joinedSuccessfully,
      createdSuccessfully: createdSuccessfully ?? this.createdSuccessfully,
      joinFailedPrefix: joinFailedPrefix ?? this.joinFailedPrefix,
      createFailedPrefix: createFailedPrefix ?? this.createFailedPrefix,
      chooseGroupFirst: chooseGroupFirst ?? this.chooseGroupFirst,
      unknownUserInitial: unknownUserInitial ?? this.unknownUserInitial,
      navGroups: navGroups ?? this.navGroups,
      navTasks: navTasks ?? this.navTasks,
      navProfile: navProfile ?? this.navProfile,
      nameUpdated: nameUpdated ?? this.nameUpdated,
      passwordChanged: passwordChanged ?? this.passwordChanged,
      backendDidNotReturnAvatarUrl: backendDidNotReturnAvatarUrl ?? this.backendDidNotReturnAvatarUrl,
      photoUpdated: photoUpdated ?? this.photoUpdated,
      accountDeleted: accountDeleted ?? this.accountDeleted,
      errorDeletingAccount: errorDeletingAccount ?? this.errorDeletingAccount,
      deleteAccountDialogTitle: deleteAccountDialogTitle ?? this.deleteAccountDialogTitle,
      deleteAccountDialogBody: deleteAccountDialogBody ?? this.deleteAccountDialogBody,
      cancelBtn: cancelBtn ?? this.cancelBtn,
      deleteBtn: deleteBtn ?? this.deleteBtn,
      deleteAccountBtn: deleteAccountBtn ?? this.deleteAccountBtn,
      saveNameBtn: saveNameBtn ?? this.saveNameBtn,
      updatePasswordBtn: updatePasswordBtn ?? this.updatePasswordBtn,
      uploading: uploading ?? this.uploading,
      deleting: deleting ?? this.deleting,
      personalInfoTitle: personalInfoTitle ?? this.personalInfoTitle,
      nameSectionTitle: nameSectionTitle ?? this.nameSectionTitle,
      changePasswordSectionTitle: changePasswordSectionTitle ?? this.changePasswordSectionTitle,
      dangerZoneTitle: dangerZoneTitle ?? this.dangerZoneTitle,
      yourNameLabel: yourNameLabel ?? this.yourNameLabel,
      emailLabel: emailLabel ?? this.emailLabel,
      oldPasswordLabel: oldPasswordLabel ?? this.oldPasswordLabel,
      changePhoto: changePhoto ?? this.changePhoto,
      deletePermanentHint: deletePermanentHint ?? this.deletePermanentHint,
      langEnglish: langEnglish ?? this.langEnglish,
      langGerman: langGerman ?? this.langGerman,
      langArabic: langArabic ?? this.langArabic,
      byHaski: byHaski ?? this.byHaski,
      myTasks: myTasks ?? this.myTasks,
      sessionExpiredPleaseRelogin: sessionExpiredPleaseRelogin ?? this.sessionExpiredPleaseRelogin,
      nameRequiredSaveFirst: nameRequiredSaveFirst ?? this.nameRequiredSaveFirst,
      home: home ?? this.home,
      addFamilyMembers: addFamilyMembers ?? this.addFamilyMembers,
      profile: profile ?? this.profile,
    );
  }

}

/// ===============================
/// Base language (EN)  ✅ default
/// ===============================
const AppStrings _enStrings = AppStrings(
  // Core
  appTitle: 'AI Family Organizer',
  setupTitle: 'Family Setup',
  setupHint: 'Add your family members:',
  addMemberLabel: 'Member name',
  noMembersYet: 'No members yet 👀',
  finishSetupButton: 'Done!',
  currentUserLabel: 'I am:',

  // Tasks
  newTaskPlaceholder: 'Add new task',
  noTasksYet: 'No tasks yet ✨',
  addedBy: 'Added by',
  createdAt: 'Created at',
  taskFree: 'Not taken',
  taskTakenBy: 'Taken by',
  takeTask: 'Take',
  releaseTask: 'Release',
  reservedTask: 'Reserved',

  // Profile
  noName: 'No name',
  noEmail: 'No email',
  settingsTitle: 'SETTINGS',
  languageTitle: 'Language',
  chooseLanguageTitle: 'Choose language',
  close: 'Close',
  logout: 'Logout',
  sessionExpiredPleaseRelogin: 'Session expired. Please log in again.',
  nameRequiredSaveFirst: 'Name is required. Please save your name first.',


  // Auth common
  emailAddressLabel: 'EMAIL ADDRESS',
  emailRequired: 'Email is required',
  emailInvalid: 'Invalid email',
  passwordLabel: 'PASSWORD',
  requiredField: 'Required',

  // Login
  signInBtn: 'SIGN IN →',
  forgotPassword: 'Forgot password?',
  noAccount: "Don't have an account? ",
  createNest: 'Create a Nest',
  loginInvalidCredentials: 'Invalid email or password',

  // Forgot password
  forgotPasswordHint: 'Enter your email to receive a verification code',
  sendCodeBtn: 'SEND CODE →',
  failedToSendCode: 'Failed to send code. Check the email and try again.',

  // Verify code
  verifyCodeTitle: 'Verification',
  codeLabel: '6-DIGIT CODE',
  codeRequired: 'Code is required',
  codeMustBe6Digits: 'Must be 6 digits',
  verifyBtn: 'VERIFY →',
  invalidOrExpiredCode: 'Invalid or expired code. Try again.',
  verifyCodeHint: 'Enter the 6-digit code sent to your email',

  // Reset password
  setNewPasswordTitle: 'Set a new password',
  newPasswordLabel: 'NEW PASSWORD',
  passwordRequired: 'Password required',
  passwordMin6: 'Min 6 characters',
  confirmPasswordLabel: 'CONFIRM PASSWORD',
  confirmRequired: 'Confirmation required',
  passwordsDoNotMatch: 'Passwords do not match',
  resetPasswordBtn: 'RESET PASSWORD →',
  resetFailedSessionExpired: 'Reset failed. Session may have expired.',
  passwordChangedSuccessfully: 'Password changed successfully',
  passwordChangedSuccess : 'Password changed successfully',
  resetFailedExpired : 'Reset failed. Session may have expired.',
  resetPasswordTitle: 'Reset password',

  // Register
  nameLabel: 'NAME',
  nameRequired: 'Name required',
  passwordMinChars: 'Min 4 chars',

  familySectionTitle: 'FAMILY',
  familyCodeOptionalLabel: 'FAMILY CODE (OPTIONAL)',
  familyCodeHint: 'If you have an invite code',
  orLabel: 'OR',
  familyNameOptionalLabel: 'FAMILY NAME (OPTIONAL)',
  familyNameHint: 'Create a new family',

  createAccountBtn: 'CREATE ACCOUNT →',
  chooseOnlyOneFamilyCodeOrName: 'Choose only one: Family code OR Family name',
  registerFailedPrefix: 'Register failed:',
  // group List screen
  showInviteCode: 'Show invite code',
  copyCode: 'Copy code',
  shareCode: 'Share code',
  codeCopied: 'Code copied',
  shareInviteTemplate: 'Join my family group using this code: {code}',
  inviteCodeTitle: 'Invite code',
  copyBtn: 'Copy',
  closeBtn: 'Close',
  groupsEmptyHint: 'Your groups will appear here',
  roleLabel: 'Role',
  // group tasks
  pleaseLoginAgain: 'Please login again',
  groupDefaultTitle: 'Group',
  addBtn: 'Add',
  errorPrefix: 'Error',
  duePrefix: 'Due',
  doneBtn: 'Done',
  taskOverdue: 'Overdue',
  taskDueSoon: 'Due soon',

  // main shell
  titleMyGroups: 'My groups',
  titleTasks: 'Tasks',
  titleProfile: 'Profile',

  addGroupTitle: 'Add group',
  joinByCodeTitle: 'Join by code',
  createNewGroupTitle: 'Create new group',

  enterInviteCode: 'Enter invite code',
  inviteCodeHint: 'Invite code',
  enterGroupName: 'Enter group name',
  groupNameHint: 'Group name',

  joinBtn: 'Join',
  createBtn: 'Create',

  joinedSuccessfully: 'Joined successfully',
  createdSuccessfully: 'Created successfully',

  joinFailedPrefix: 'Join failed',
  createFailedPrefix: 'Create failed',

  chooseGroupFirst: 'Choose a group first',
  unknownUserInitial: 'U',

  navGroups: 'Groups',
  navTasks: 'Tasks',
  navProfile: 'Profile',
  // personal info
  nameUpdated: 'Name updated',
  passwordChanged: 'Password changed',
  backendDidNotReturnAvatarUrl: 'Backend did not return avatar URL',
  photoUpdated: 'Photo updated',
  accountDeleted: 'Account deleted',
  errorDeletingAccount: 'Error deleting account',

  deleteAccountDialogTitle: 'Delete account',
  deleteAccountDialogBody: 'Are you sure? This action cannot be undone.',
  cancelBtn: 'Cancel',
  deleteBtn: 'Delete',
  deleteAccountBtn: 'Delete account',
  saveNameBtn: 'Save name',
  updatePasswordBtn: 'Update password',
  uploading: 'Uploading...',
  deleting: 'Deleting...',
  personalInfoTitle: 'Personal info',
  nameSectionTitle: 'Name',
  changePasswordSectionTitle: 'Change password',
  dangerZoneTitle: 'Danger zone',
  yourNameLabel: 'Your name',
  emailLabel: 'Email',
  oldPasswordLabel: 'Old password',
  changePhoto: 'Change photo',
  deletePermanentHint: 'Deleting your account is permanent.',
// ===== Profile =====

  langEnglish: 'English',
  langGerman: 'German',
  langArabic: 'Arabic',
  byHaski: 'by HASKI',
  myTasks: 'My Tasks',

  home: 'Home',
  addFamilyMembers: 'Add family members',
  profile: 'Profile',
  // ...

);

// ===============================
// German (DE) - partial, fallback to EN
// ===============================
final AppStrings _deStrings = _enStrings.copyWith(
  appTitle: 'AI Familien-Organizer',
  setupTitle: 'Familien-Setup',
  setupHint: 'Füge deine Familienmitglieder hinzu:',
  addMemberLabel: 'Mitgliedsname',
  noMembersYet: 'Noch keine Mitglieder 👀',
  finishSetupButton: 'Fertig!',
  currentUserLabel: 'Ich bin:',

  newTaskPlaceholder: 'Neue Aufgabe hinzufügen',
  noTasksYet: 'Noch keine Aufgaben ✨',
  addedBy: 'Hinzugefügt von',
  createdAt: 'Erstellt am',
  taskFree: 'Nicht übernommen',
  taskTakenBy: 'Übernommen von',
  takeTask: 'Übernehmen',
  releaseTask: 'Freigeben',
  reservedTask: 'Reserviert',
  home: 'Startseite',
  addFamilyMembers: 'Familienmitglieder hinzufügen',
  profile: 'Profil',

  noName: 'Kein Name',
  noEmail: 'Keine E-Mail',
  settingsTitle: 'EINSTELLUNGEN',
  languageTitle: 'Sprache',
  chooseLanguageTitle: 'Sprache wählen',
  close: 'Schließen',
  logout: 'Abmelden',

  emailAddressLabel: 'E-MAIL-ADRESSE',
  emailRequired: 'E-Mail ist erforderlich',
  emailInvalid: 'Ungültige E-Mail',
  passwordLabel: 'PASSWORT',
  requiredField: 'Erforderlich',

  signInBtn: 'ANMELDEN →',
  forgotPassword: 'Passwort vergessen?',
  noAccount: 'Kein Konto? ',
  createNest: 'Nest erstellen',
  loginInvalidCredentials: 'E-Mail oder Passwort falsch',

  forgotPasswordHint: 'Gib deine E-Mail ein, um einen Code zu erhalten',
  sendCodeBtn: 'CODE SENDEN →',
  failedToSendCode: 'Code konnte nicht gesendet werden. Bitte prüfen und erneut versuchen.',

  verifyCodeTitle: 'Bestätigung',
  codeLabel: '6-STELLIGER CODE',
  codeRequired: 'Code ist erforderlich',
  codeMustBe6Digits: 'Muss 6 Ziffern haben',
  verifyBtn: 'BESTÄTIGEN →',
  invalidOrExpiredCode: 'Ungültiger oder abgelaufener Code. Bitte erneut versuchen.',
  verifyCodeHint: 'Gib den 6-stelligen Code aus der E-Mail ein',

  setNewPasswordTitle: 'Neues Passwort festlegen',
  newPasswordLabel: 'NEUES PASSWORT',
  passwordRequired: 'Passwort erforderlich',
  passwordMin6: 'Mind. 6 Zeichen',
  confirmPasswordLabel: 'PASSWORT BESTÄTIGEN',
  confirmRequired: 'Bestätigung erforderlich',
  passwordsDoNotMatch: 'Passwörter stimmen nicht überein',
  resetPasswordBtn: 'PASSWORT ZURÜCKSETZEN →',
  resetFailedSessionExpired: 'Zurücksetzen fehlgeschlagen. Sitzung evtl. abgelaufen.',
  passwordChangedSuccessfully: 'Passwort erfolgreich geändert',
  passwordChangedSuccess: 'Passwort erfolgreich geändert',
  resetFailedExpired: 'Zurücksetzen fehlgeschlagen. Sitzung evtl. abgelaufen.',
  resetPasswordTitle: 'Passwort zurücksetzen',

  nameLabel: 'NAME',
  nameRequired: 'Name erforderlich',
  passwordMinChars: 'Mind. 4 Zeichen',

  familySectionTitle: 'FAMILIE',
  familyCodeOptionalLabel: 'FAMILIENCODE (OPTIONAL)',
  familyCodeHint: 'Wenn du einen Einladungs-Code hast',
  orLabel: 'ODER',
  familyNameOptionalLabel: 'FAMILIENNAME (OPTIONAL)',
  familyNameHint: 'Neue Familie erstellen',

  createAccountBtn: 'KONTO ERSTELLEN →',
  chooseOnlyOneFamilyCodeOrName: 'Nur eins wählen: Familiencode ODER Familienname',
  registerFailedPrefix: 'Registrierung fehlgeschlagen:',

  showInviteCode: 'Einladungscode anzeigen',
  copyCode: 'Code kopieren',
  shareCode: 'Code teilen',
  codeCopied: 'Code kopiert',
  shareInviteTemplate: 'Tritt meiner Familie mit diesem Code bei: {code}',
  inviteCodeTitle: 'Einladungscode',
  copyBtn: 'Kopieren',
  closeBtn: 'Schließen',
  groupsEmptyHint: 'Deine Gruppen erscheinen hier',
  roleLabel: 'Rolle',

  pleaseLoginAgain: 'Bitte erneut anmelden',
  groupDefaultTitle: 'Gruppe',
  addBtn: 'Hinzufügen',
  errorPrefix: 'Fehler',
  duePrefix: 'Fällig',
  doneBtn: 'Erledigt',
  taskOverdue: 'Überfällig',
  taskDueSoon: 'Bald fällig',
  sessionExpiredPleaseRelogin: 'Sitzung abgelaufen. Bitte erneut anmelden.',
  nameRequiredSaveFirst: 'Name ist erforderlich. Bitte speichern Sie zuerst Ihren Namen.',

  titleMyGroups: 'Meine Gruppen',
  titleTasks: 'Aufgaben',
  titleProfile: 'Profil',

  addGroupTitle: 'Gruppe hinzufügen',
  joinByCodeTitle: 'Mit Code beitreten',
  createNewGroupTitle: 'Neue Gruppe erstellen',

  enterInviteCode: 'Einladungscode eingeben',
  inviteCodeHint: 'Einladungscode',
  enterGroupName: 'Gruppenname eingeben',
  groupNameHint: 'Gruppenname',

  joinBtn: 'Beitreten',
  createBtn: 'Erstellen',

  joinedSuccessfully: 'Erfolgreich beigetreten',
  createdSuccessfully: 'Erfolgreich erstellt',

  joinFailedPrefix: 'Beitritt fehlgeschlagen',
  createFailedPrefix: 'Erstellen fehlgeschlagen',

  chooseGroupFirst: 'Wähle zuerst eine Gruppe',
  unknownUserInitial: 'U',

  navGroups: 'Gruppen',
  navTasks: 'Aufgaben',
  navProfile: 'Profil',

  nameUpdated: 'Name aktualisiert',
  passwordChanged: 'Passwort geändert',
  backendDidNotReturnAvatarUrl: 'Backend hat keine Avatar-URL zurückgegeben',
  photoUpdated: 'Foto aktualisiert',
  accountDeleted: 'Konto gelöscht',
  errorDeletingAccount: 'Fehler beim Löschen des Kontos',

  deleteAccountDialogTitle: 'Konto löschen',
  deleteAccountDialogBody: 'Bist du sicher? Diese Aktion kann nicht rückgängig gemacht werden.',
  cancelBtn: 'Abbrechen',
  deleteBtn: 'Löschen',
  deleteAccountBtn: 'Konto löschen',
  saveNameBtn: 'Name speichern',
  updatePasswordBtn: 'Passwort aktualisieren',
  uploading: 'Wird hochgeladen...',
  deleting: 'Wird gelöscht...',
  personalInfoTitle: 'Persönliche Infos',
  nameSectionTitle: 'Name',
  changePasswordSectionTitle: 'Passwort ändern',
  dangerZoneTitle: 'Gefahrenzone',

  yourNameLabel: 'Dein Name',
  emailLabel: 'E-Mail',
  oldPasswordLabel: 'Altes Passwort',
  changePhoto: 'Foto ändern',
  deletePermanentHint: 'Das Löschen deines Kontos ist dauerhaft.',

  langEnglish: 'Englisch',
  langGerman: 'Deutsch',
  langArabic: 'Arabisch',

  myTasks: 'Meine Aufgaben',
);

// ===============================
// Arabic (AR) - partial, fallback to EN
// ===============================
final AppStrings _arStrings = _enStrings.copyWith(
  appTitle: 'منظّم العائلة الذكي',
  setupTitle: 'إعداد العائلة',
  setupHint: 'أضيفي أفراد العائلة:',
  addMemberLabel: 'اسم العضو',
  noMembersYet: 'لا يوجد أعضاء بعد 👀',
  finishSetupButton: 'تم!',
  currentUserLabel: 'أنا:',

  newTaskPlaceholder: 'إضافة مهمة جديدة',
  noTasksYet: 'لا يوجد مهام بعد ✨',
  addedBy: 'أضيفت بواسطة',
  createdAt: 'تاريخ الإنشاء',
  taskFree: 'غير محجوزة',
  taskTakenBy: 'محجوزة بواسطة',
  takeTask: 'احجز',
  releaseTask: 'إلغاء الحجز',
  reservedTask: 'محجوزة',
  home: 'الرئيسية',
  addFamilyMembers: 'إضافة أفراد العائلة',
  profile: 'حسابي',

  noName: 'بدون اسم',
  noEmail: 'بدون بريد',
  settingsTitle: 'الإعدادات',
  languageTitle: 'اللغة',
  chooseLanguageTitle: 'اختيار اللغة',
  close: 'إغلاق',
  logout: 'تسجيل الخروج',

  emailAddressLabel: 'البريد الإلكتروني',
  emailRequired: 'البريد مطلوب',
  emailInvalid: 'بريد غير صالح',
  passwordLabel: 'كلمة المرور',
  requiredField: 'مطلوب',

  signInBtn: 'تسجيل الدخول →',
  forgotPassword: 'نسيتِ كلمة المرور؟',
  noAccount: 'ما عندك حساب؟ ',
  createNest: 'إنشاء حساب',
  loginInvalidCredentials: 'البريد أو كلمة المرور غير صحيحة',

  forgotPasswordHint: 'أدخلي بريدك لاستلام رمز التحقق',
  sendCodeBtn: 'إرسال الرمز →',
  failedToSendCode: 'فشل إرسال الرمز. تحققي من البريد وحاولي مجدداً.',

  verifyCodeTitle: 'التحقق',
  codeLabel: 'رمز من 6 أرقام',
  codeRequired: 'الرمز مطلوب',
  codeMustBe6Digits: 'لازم 6 أرقام',
  verifyBtn: 'تحقق →',
  invalidOrExpiredCode: 'رمز غير صالح أو منتهي. حاولي مجدداً.',
  verifyCodeHint: 'أدخلي الرمز المرسل إلى بريدك',

  setNewPasswordTitle: 'تعيين كلمة مرور جديدة',
  newPasswordLabel: 'كلمة مرور جديدة',
  passwordRequired: 'كلمة المرور مطلوبة',
  passwordMin6: 'الحد الأدنى 6 أحرف',
  confirmPasswordLabel: 'تأكيد كلمة المرور',
  confirmRequired: 'التأكيد مطلوب',
  passwordsDoNotMatch: 'كلمتا المرور غير متطابقتين',
  resetPasswordBtn: 'إعادة تعيين →',
  resetFailedSessionExpired: 'فشل إعادة التعيين. ممكن الجلسة انتهت.',
  passwordChangedSuccessfully: 'تم تغيير كلمة المرور بنجاح',
  passwordChangedSuccess: 'تم تغيير كلمة المرور بنجاح',
  resetFailedExpired: 'فشل إعادة التعيين. ممكن الجلسة انتهت.',
  resetPasswordTitle: 'إعادة تعيين كلمة المرور',

  nameLabel: 'الاسم',
  nameRequired: 'الاسم مطلوب',
  passwordMinChars: 'الحد الأدنى 4 أحرف',

  familySectionTitle: 'العائلة',
  familyCodeOptionalLabel: 'كود العائلة (اختياري)',
  familyCodeHint: 'إذا معك كود دعوة',
  orLabel: 'أو',
  familyNameOptionalLabel: 'اسم العائلة (اختياري)',
  familyNameHint: 'إنشاء عائلة جديدة',

  createAccountBtn: 'إنشاء حساب →',
  chooseOnlyOneFamilyCodeOrName: 'اختاري واحد فقط: كود العائلة أو اسم العائلة',
  registerFailedPrefix: 'فشل التسجيل:',

  showInviteCode: 'عرض كود الدعوة',
  copyCode: 'نسخ الكود',
  shareCode: 'مشاركة الكود',
  codeCopied: 'تم نسخ الكود',
  shareInviteTemplate: 'انضمّي لمجموعتي باستخدام الكود: {code}',
  inviteCodeTitle: 'كود الدعوة',
  copyBtn: 'نسخ',
  closeBtn: 'إغلاق',
  groupsEmptyHint: 'ستظهر مجموعاتك هنا',
  roleLabel: 'الدور',

  pleaseLoginAgain: 'الرجاء تسجيل الدخول مرة أخرى',
  groupDefaultTitle: 'مجموعة',
  addBtn: 'إضافة',
  errorPrefix: 'خطأ',
  duePrefix: 'موعد',
  doneBtn: 'تم',
  taskOverdue: 'متأخرة',
  taskDueSoon: 'قريبة',

  titleMyGroups: 'مجموعاتي',
  titleTasks: 'المهام',
  titleProfile: 'الملف الشخصي',

  addGroupTitle: 'إضافة مجموعة',
  joinByCodeTitle: 'انضمام عبر كود',
  createNewGroupTitle: 'إنشاء مجموعة جديدة',

  enterInviteCode: 'أدخل كود الدعوة',
  inviteCodeHint: 'كود الدعوة',
  enterGroupName: 'أدخل اسم المجموعة',
  groupNameHint: 'اسم المجموعة',

  joinBtn: 'انضمام',
  createBtn: 'إنشاء',

  joinedSuccessfully: 'تم الانضمام بنجاح',
  createdSuccessfully: 'تم الإنشاء بنجاح',

  joinFailedPrefix: 'فشل الانضمام',
  createFailedPrefix: 'فشل الإنشاء',

  chooseGroupFirst: 'اختاري مجموعة أولاً',
  unknownUserInitial: 'م',

  navGroups: 'المجموعات',
  navTasks: 'المهام',
  navProfile: 'حسابي',

  nameUpdated: 'تم تحديث الاسم',
  passwordChanged: 'تم تغيير كلمة المرور',
  backendDidNotReturnAvatarUrl: 'السيرفر لم يرجع رابط الصورة',
  photoUpdated: 'تم تحديث الصورة',
  accountDeleted: 'تم حذف الحساب',
  errorDeletingAccount: 'خطأ بحذف الحساب',

  deleteAccountDialogTitle: 'حذف الحساب',
  deleteAccountDialogBody: 'هل أنتِ متأكدة؟ هذا الإجراء لا يمكن التراجع عنه.',
  cancelBtn: 'إلغاء',
  deleteBtn: 'حذف',
  deleteAccountBtn: 'حذف الحساب',
  saveNameBtn: 'حفظ الاسم',
  updatePasswordBtn: 'تحديث كلمة المرور',
  uploading: 'جاري الرفع...',
  deleting: 'جاري الحذف...',
  personalInfoTitle: 'المعلومات الشخصية',
  nameSectionTitle: 'الاسم',
  changePasswordSectionTitle: 'تغيير كلمة المرور',
  dangerZoneTitle: 'منطقة الخطر',

  yourNameLabel: 'اسمك',
  emailLabel: 'البريد',
  oldPasswordLabel: 'كلمة المرور القديمة',
  changePhoto: 'تغيير الصورة',
  deletePermanentHint: 'حذف الحساب نهائي.',
  sessionExpiredPleaseRelogin: 'انتهت الجلسة. الرجاء تسجيل الدخول من جديد.',
  nameRequiredSaveFirst: 'الاسم مطلوب. الرجاء حفظ الاسم أولاً.',

  langEnglish: 'الإنجليزية',
  langGerman: 'الألمانية',
  langArabic: 'العربية',

  myTasks: 'مهامي',
);


/// ===============================
/// Language map (fallback to EN)
/// ===============================
final Map<AppLang, AppStrings> kStrings = {
  AppLang.en: _enStrings,
  AppLang.de: _deStrings,
  AppLang.ar: _arStrings,

  // حاليا ما عندك fr/es/it/tr/ru جاهزين، خليهم fallback للإنكليزي
  AppLang.fr: _enStrings,
  AppLang.es: _enStrings,
  AppLang.it: _enStrings,
  AppLang.tr: _enStrings,
  AppLang.ru: _enStrings,
};

String shortLang(AppLang lang) => lang.name.toUpperCase();
