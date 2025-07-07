enum AccountType { SAVINGS, CURRENT }
enum AccountStatus { ACTIVE, INACTIVE, SUSPEND, REQUESTED }

String accountTypeToString(AccountType type) {
  switch (type) {
    case AccountType.SAVINGS:
      return "Savings";
    case AccountType.CURRENT:
      return "Current";
  }
}

String accountStatusToString(AccountStatus status) {
  switch (status) {
    case AccountStatus.ACTIVE:
      return "Active";
    case AccountStatus.INACTIVE:
      return "Inactive";
    case AccountStatus.REQUESTED:
      return "Requested";
    case AccountStatus.SUSPEND:
      return "Suspended";
  }
}
