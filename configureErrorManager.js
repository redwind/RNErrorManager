const ErrorUtils = require('ErrorUtils');

import { NativeModules } from 'react-native';
import parseErrorStack from 'parseErrorStack';
import _ from 'underscore';

const ErrorManager = NativeModules.ErrorManager;

let exceptionID = 0;

if (ErrorManager && ErrorUtils._globalHandler) {

  const previousGlobalHandler = ErrorUtils._globalHandler;
  const wrapGlobalHandler = (error, isFatal) => {
    let currentExceptionID = ++exceptionID;
    const stack = parseErrorStack(error);

    const timeoutPromise = new Promise((resolve) => {
      global.setTimeout(() => {
        resolve();
      }, 1000);
    });

    const reportExceptionPromise = new Promise((resolve) => {
      ErrorManager.reportException(error.message, stack, currentExceptionID, {}, resolve);
    });

    return Promise.race([reportExceptionPromise, timeoutPromise]).then(() => {
      previousGlobalHandler(error, isFatal);
    });
  };
  ErrorUtils.setGlobalHandler(wrapGlobalHandler);
}

global.notifyError = (error, errorData) => {
  if (error instanceof Error) {
    console.log('notifyError', error, errorData);
    let currentExceptionID = ++exceptionID;
    const stack = parseErrorStack(error);

    ErrorManager.reportException(
      error.message,
      stack,
      currentExceptionID,
      // Make all values string
      _.mapObject(errorData || {}, (val, key) => (val || 'NULL').toString()),
      () => {}
    );
  } else {
    console.warn('attempt to call notifyError without an Error', error, errorData);
  }
}