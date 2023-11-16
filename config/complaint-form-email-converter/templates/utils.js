export function senderName(form) {
  let senderName = form.name;
  if (form.contactPersonName != '-') {
    senderName = form.name;
  }
  return senderName;
}

export function humanReadableSize(size) {
  const bytes = size;
  const sizes = ['bytes', 'KB', 'MB', 'GB', 'TB'];
  if (bytes == 0) return '0 byte';
  const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
  return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
}
