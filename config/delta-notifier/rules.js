import resources from './resources';
import erroralert from './error-alert';
import complaintConverter from './complaintConverter';

export default [
  ...resources,
  ...complaintConverter,
  ...erroralert,
];
