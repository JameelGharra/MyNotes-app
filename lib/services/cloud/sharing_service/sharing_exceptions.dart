class CloudSharingException implements Exception {
  const CloudSharingException();
}

class CouldNotFetchBlockedUsers extends CloudSharingException {}

class CouldNotUpdateBlockListException extends CloudSharingException {}

class CouldNotUnblockUserException extends CloudSharingException {}

class SharingForUserExistsException extends CloudSharingException {}

class CouldNotCreateSharingForUserException extends CloudSharingException {}

class CouldNotFindSharingForUserException extends CloudSharingException {}
