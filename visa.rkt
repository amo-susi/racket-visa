#lang racket
(require ffi/unsafe
         racket/runtime-path)

(provide vi-open-default-rm
         vi-open
         vi-write
         vi-read
         vi-close
         vi-gpib-control-ren)

;;; library
(define-runtime-path visa32-library-path
  (case (system-type)
    [(windows) '(so "visa32")]))

(define visa-lib (ffi-lib visa32-library-path))


;;; operations

;; Asserts the specified interrupt or signal.
(define vi-assert-intr-signal
  (get-ffi-obj "viAssertIntrSignal" visa-lib
               (_fun (vi : _uint32)
                     (mode : _int16)
                     (statusID : _uint32)
                     -> (ViStatus : _long))))

;; Asserts software or hardware trigger.
(define vi-assert-trigger
  (get-ffi-obj "viAssertTrigger" visa-lib
               (_fun (vi : _uint32)
                     (protocol : _uint16)
                     -> (ViStatus : _long))))

;; Asserts or deasserts the specified utility bus signal.
(define vi-assert-util-signal
  (get-ffi-obj "viAssertUtilSignal" visa-lib
               (_fun (vi : _uint32)
                     (line : _uint16)
                     -> (ViStatus : _long))))

;; Reads data from device or interface through the use of a formatted I/O read buffer.
(define vi-buf-read
  (get-ffi-obj "viBufRead" visa-lib
               (_fun (vi : _uint32)
                     (buf : (_ptr o _string))
                     (count : _uint32)
                     (retCount : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus buf retCount))))

;; Writes data to a formatted I/O write buffer synchronously.
(define vi-buf-write
  (get-ffi-obj "viBufWrite" visa-lib
               (_fun (vi : _uint32)
                     (buf : _string)
                     (count : _uint32)
                     (retCount : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus retCount))))

;; Clears a device.
(define vi-clear
  (get-ffi-obj "viClear" visa-lib
               (_fun (vi : _uint32)
                     -> (ViStatus : _long))))

;; Closes the specified session, event, or find list.
(define vi-close
  (get-ffi-obj "viClose" visa-lib
               (_fun (vi : _uint32)
                     -> (ViStatus : _long))))

;; Disables notification of the specified event type(s) via the specified mechanism(s).
(define vi-disable-event
  (get-ffi-obj "viDisableEvent" visa-lib
               (_fun (vi : _uint32)
                     (eventType : _long)
                     (mechanism : _uint16)
                     -> (ViStatus : _long))))

;; Discards event occurrences for specified event types and mechanisms in a session.
(define vi-discard-events
  (get-ffi-obj "viDiscardEvents" visa-lib
               (_fun (vi : _uint32)
                     (eventType : _long)
                     (mechanism : _uint16)
                     -> (ViStatus : _long))))

;; Enables notification of a specified event.
(define vi-enable-event
  (get-ffi-obj "viEnableEvent" visa-lib
               (_fun (vi : _uint32)
                     (eventType : _long)
                     (mechanism : _uint16)
                     (context : _long)
                     -> (ViStatus : _long))))

#|
;; Event service handler procedure prototype.
(define vi-event-handler
  (get-ffi-obj "viEventHandler" visa-lib
               (_fun (vi : _uint32)
                     (eventType : _long)
                     (context : _long)
                     (userHnadle : _void)
                     -> (ViStatus : _long))))
|#

;; Returns the next resource from the list of resources found during a previous call to viFindRsrc().
(define vi-find-next
  (get-ffi-obj "viFindNext" visa-lib
               (_fun (findList : _long)
                     (instrDesc : (_ptr o _string))
                     -> (ViStatus : _long)
                     -> (values ViStatus instrDesc))))
               
;; Queries a VISA system to locate the resources associated with a specified interface.
(define vi-find-rsrc
  (get-ffi-obj "viFindRsrc" visa-lib
               (_fun (sesn : _uint32)
                     (expr : _string)
                     (findList : (_ptr o _long))
                     (retcnt : (_ptr o _uint32))
                     (instrDesc : (_ptr o _string))
                     -> (ViStatus : _long)
                     -> (values ViStatus findList retcnt instrDesc))))

;; Manually flushes the specified buffers associated with formatted I/O operations and/or serial communication.
(define vi-flush
  (get-ffi-obj "viFlush" visa-lib
               (_fun (vi : _uint32)
                     (mask : _uint16)
                     -> (ViStatus : _long))))


;; Retrieves the state of an attribute.
(define vi-get-attribute
  (get-ffi-obj "viGetAttribute" visa-lib
               (_fun (vi : _uint32)
                     (attribute : _uint32)
                     (attrState : (_ptr o _void))
                     -> (ViStatus : _long)
                     -> (values ViStatus attrState))))

;; Write GPIB command bytes on the bus.
(define vi-gpib-command
  (get-ffi-obj "viGpibCommand" visa-lib
               (_fun (vi : _uint32)
                     (buf : _string)
                     (count : _uint32)
                     (retCount : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus retCount))))

;; Specifies the state of the ATN line and the local active controller state.
(define vi-gpib-control-atn
  (get-ffi-obj "viGpibControlATN" visa-lib
               (_fun (vi : _uint32)
                     (mode : _uint16)
                     -> (ViStatus : _long))))

;; Controls the state of the GPIB Remote Enable (REN) interface line, and optionally the remote/local state of the device.
(define vi-gpib-control-ren
  (get-ffi-obj "viGpibControlREN" visa-lib
               (_fun (vi : _uint32)
                     (mode : _uint16)
                     -> (ViStatus : _long))))

;; Tell the GPIB device at the specified address to become controller in charge (CIC).
(define vi-gpib-pass-control
  (get-ffi-obj "viGpibPassControl" visa-lib
               (_fun (vi : _uint32)
                     (primAddr : _uint16)
                     (secAddr : _uint16)
                     -> (ViStatus : _long))))

;; Pulse the interface clear line (IFC) for at least 100 microseconds.
(define vi-gpib-send-ifc
  (get-ffi-obj "viGpibSendIFC" visa-lib
               (_fun (vi : _uint32)
                     -> (ViStatus : _long))))

;; Reads in an 8-bit, 16-bit, or 32-bit value from the specified memory space and offset.
(define vi-in8
  (get-ffi-obj "viIn8" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (val8 : (_ptr o _uint8))
                     -> (ViStatus : _long)
                     -> (values ViStatus val8))))

(define vi-in16
  (get-ffi-obj "viIn16" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (val16 : (_ptr o _uint16))
                     -> (ViStatus : _long)
                     -> (values ViStatus val16))))

(define vi-in32
  (get-ffi-obj "viIn32" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (val32 : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus val32))))

;; Installs handlers for event callbacks.
(define vi-install-handler
  (get-ffi-obj "viInstallHandler" visa-lib
               (_fun (vi : _uint32)
                     (eventType : _long)
                     (handler : _long)
                     (userHandle : (_ptr i _void))
                     -> (ViStatus : _long))))

;; Establishes an access mode to the specified resource.
(define vi-lock
  (get-ffi-obj "viLock" visa-lib
               (_fun (vi : _uint32)
                     (lockType : _long)
                     (timeout : _uint32)
                     (requestedKey : _string)
                     (accessKey : (_ptr o _string))
                     -> (ViStatus : _long)
                     -> (values ViStatus accessKey))))
                     
;; Maps the specified memory space into the process’s address space.
(define vi-map-address
  (get-ffi-obj "viMapAddress" visa-lib
               (_fun (vi : _uint32)
                     (mapSpace : _uint16)
                     (mapBase : _long)
                     (mapSize : _long)
                     (access : _uint16)
                     (suggested : (_ptr i _void))
                     (address : (_ptr o _void))
                     -> (ViStatus : _long)
                     -> (values ViStatus address))))

;; Map the specified trigger source line to the specified destination line.
(define vi-map-trigger
  (get-ffi-obj "viMapTrigger" visa-lib
               (_fun (vi : _uint32)
                     (trigSrc : _int16)
                     (trigDest : _int16)
                     (mode : _uint16)
                     -> (ViStatus : _long))))

;; Allocates memory from a device’s memory region.
(define vi-mem-alloc
  (get-ffi-obj "viMemAlloc" visa-lib
               (_fun (vi : _uint32)
                     (size : _long)
                     (offset : (_ptr o _long))
                     -> (ViStatus : _long)
                     -> (values ViStatus offset))))


;; Frees memory previously allocated using the viMemAlloc() operation.
(define vi-mem-free
  (get-ffi-obj "viMemFree" visa-lib
               (_fun (vi : _uint32)
                     (offset : _long)
                     -> (ViStatus : _long))))

;; Moves a block of data.
(define vi-move
  (get-ffi-obj "viMove" visa-lib
               (_fun (vi : _uint32)
                     (srcSpace : _uint16)
                     (srcOffset : _long)
                     (srcWidth : _uint16)
                     (destSpace : _uint16)
                     (destOffset : _long)
                     (destWidth : _uint16)
                     (length : _long)
                     -> (ViStatus : _long))))

;; Moves a block of data asynchronously.
(define vi-move-async
  (get-ffi-obj "viMoveAsync" visa-lib
               (_fun (vi : _uint32)
                     (srcSpace : _uint16)
                     (srcOffset : _long)
                     (srcWidth : _uint16)
                     (destSpace : _uint16)
                     (destOffset : _long)
                     (destWidth : _uint16)
                     (length : _long)
                     (jobId : (_ptr o _long))
                     -> (ViStatus : _long)
                     -> (values ViStatus jobId))))

;; Moves a block of data from the specified address space and offset to local memory.
(define vi-move-in8
  (get-ffi-obj "viMoveIn8" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (buf : (_ptr o _uint8))
                     -> (ViStatus : _long)
                     -> (values ViStatus buf))))

(define vi-move-in16
  (get-ffi-obj "viMoveIn16" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (buf : (_ptr o _uint16))
                     -> (ViStatus : _long)
                     -> (values ViStatus buf))))

(define vi-move-in32
  (get-ffi-obj "viMoveIn32" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (buf : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus buf))))

;; Moves a block of data from local memory to the specified address space and offset.
(define vi-move-out8
  (get-ffi-obj "viMoveOut8" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (length : _long)
                     (buf8 : _uint8)
                     -> (ViStatus : _long))))

(define vi-move-out16
  (get-ffi-obj "viMoveOut16" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (length : _long)
                     (buf16 : _uint16)
                     -> (ViStatus : _long))))

(define vi-move-out32
  (get-ffi-obj "viMoveOut32" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (length : _long)
                     (buf32 : _uint32)
                     -> (ViStatus : _long))))

;; Opens a session to the specified resource.
(define vi-open
  (get-ffi-obj "viOpen" visa-lib
               (_fun (sesn : _uint32)
                     (rsrcName : _string)
                     (accessMode : _long)
                     (openTimeout : _uint32)
                     (vi : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus vi))))

;; This function returns a session to the Default Resource Manager resource.
(define vi-open-default-rm
  (get-ffi-obj "viOpenDefaultRM" visa-lib
               (_fun (sesn : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus sesn))))

;; Writes an 8-bit, 16-bit, or 32-bit value to the specified memory space and offset.
(define vi-out8
  (get-ffi-obj "viOut8" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (val8 : _uint8)
                     -> (ViStatus : _long))))

(define vi-out16
  (get-ffi-obj "viOut16" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (val16 : _uint16)
                     -> (ViStatus : _long))))

(define vi-out32
  (get-ffi-obj "viOut32" visa-lib
               (_fun (vi : _uint32)
                     (space : _uint16)
                     (offset : _long)
                     (val32 : _uint32)
                     -> (ViStatus : _long))))

;; Parse a resource string to get the interface information.
(define vi-parse-rsrc
  (get-ffi-obj "viParseRsrc" visa-lib
               (_fun (sesn : _uint32)
                     (rsrcName : _string)
                     (intfType : (_ptr o _uint16))
                     (intfNum : (_ptr o _uint16))
                     -> (ViStatus : _long)
                     -> (values ViStatus intfType intfNum))))

;; Parse a resource string to get extended interface information.
(define vi-parse-rsrc-ex
  (get-ffi-obj "viParseRsrcEx" visa-lib
               (_fun (sesn : _uint32)
                     (rsrcName : _string)
                     (intfType : (_ptr o _uint16))
                     (intfNum : (_ptr o _uint16))
                     (rsrcClass : (_ptr o _string))
                     (expandedUnaliasedName : (_ptr o _string))
                     (aliasIfExists : (_ptr o _string))
                     -> (ViStatus : _long)
                     -> (values ViStatus intfType intfNum
                                rsrcClass expandedUnaliasedName
                                aliasIfExists))))

;; Reads an 8-bit, 16-bit, or 32-bit value from the specified address.
(define vi-peek8
  (get-ffi-obj "viPeek8" visa-lib
               (_fun (vi : _uint32)
                     (addr : (_ptr i _void))
                     (val8 : (_ptr o _uint8))
                     -> (ViStatus : _void)
                     -> (values ViStatus val8))))

(define vi-peek16
  (get-ffi-obj "viPeek16" visa-lib
               (_fun (vi : _uint32)
                     (addr : (_ptr i _void))
                     (val16 : (_ptr o _uint16))
                     -> (ViStatus : _void)
                     -> (values ViStatus val16))))

(define vi-peek32
  (get-ffi-obj "viPeek32" visa-lib
               (_fun (vi : _uint32)
                     (addr : (_ptr i _void))
                     (val32 : (_ptr o _uint32))
                     -> (ViStatus : _void)
                     -> (values ViStatus val32))))

;; Writes an 8-bit, 16-bit, or 32-bit value to the specified address.
(define vi-poke8
  (get-ffi-obj "viPoke8" visa-lib
               (_fun (vi : _uint32)
                     (addr : (_ptr i _void))
                     (val8 : _uint32)
                     -> (ViStatus : _void))))

(define vi-poke16
  (get-ffi-obj "viPoke16" visa-lib
               (_fun (vi : _uint32)
                     (addr : (_ptr i _void))
                     (val16 : _uint32)
                     -> (ViStatus : _void))))

(define vi-poke32
  (get-ffi-obj "viPoke32" visa-lib
               (_fun (vi : _uint32)
                     (addr : (_ptr i _void))
                     (val32 : _uint32)
                     -> (ViStatus : _void))))

;; Converts, formats, and sends the parameters (designated by ...) to the device as specified by the format string.
(define vi-printf
  (get-ffi-obj "viPrintf" visa-lib
               (_fun (vi : _uint32)
                     (writeFmt : _string)
                     -> (ViStatus : _long))))

;; Performs a formatted write and read through a single call to an operation.
(define vi-queryf
  (get-ffi-obj "viQueryf" visa-lib
               (_fun (vi : _uint32)
                     (writeFmt : _string)
                     (readFmt : _string)
                     -> (ViStatus : _long))))

;; Reads data from device or interface synchronously.
(define vi-read
  (get-ffi-obj "viRead" visa-lib
               (_fun (vi : _uint32)
                     (buf : (_ptr o _string))
                     (count : _uint32)
                     (retCount : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus buf retCount))))

;; Reads data from device or interface asynchronously.
(define vi-read-async
  (get-ffi-obj "viReadAsync" visa-lib
               (_fun (vi : _uint32)
                     (buf : (_ptr o _string))
                     (count : _uint32)
                     (jobId : (_ptr o _long))
                     -> (ViStatus : _long)
                     -> (values ViStatus buf jobId))))

;; Reads a status byte of the service request.
(define vi-read-stb
  (get-ffi-obj "viReadSTB" visa-lib
               (_fun (vi : _uint32)
                     (status : (_ptr o _uint16))
                     -> (ViStatus : _long)
                     -> (values ViStatus status))))

;; Read data synchronously, and store the transferred data in a file.
(define vi-read-to-file
  (get-ffi-obj "viReadToFile" visa-lib
               (_fun (vi : _uint32)
                     (fileName : _string)
                     (count : _uint32)
                     (retCount : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus retCount))))

;; Reads, converts, and formats data using the format specifier. Stores the formatted data in the parameters (designated by ...).
(define vi-scanf
  (get-ffi-obj "viScanf" visa-lib
               (_fun (vi : _uint32)
                     (readFmt : _string)
                     -> (ViStatus : _long))))

;; Sets the state of an attribute.
(define vi-ste-attribute
  (get-ffi-obj "viSetAttribute" visa-lib
               (_fun (vi : _uint32)
                     (attribute : _uint32)
                     (attrState : _long)
                     -> (ViStatus : _long))))

;; Sets the size for the formatted I/O and/or low-level I/O communication buffer(s).
(define vi-set-buf
  (get-ffi-obj "viSetBuf" visa-lib
               (_fun (vi : _uint32)
                     (mask : _uint16)
                     (size : _uint32)
                     -> (ViStatus : _long))))
;; Converts, formats, and sends the parameters (designated by ...) to a user-specified buffer as specified by the format string.
(define vi-sprintf
  (get-ffi-obj "viSPrintf" visa-lib
               (_fun (vi : _uint32)
                     (buf : (_ptr o _string))
                     (writeFmt : _string)
                     -> (ViStatus : _long)
                     -> (values ViStatus buf))))

;; Reads, converts, and formats data from a user-specified buffer using the format specifier. Stores the formatted data in the parameters (designated by ...).
(define vi-sscanf
  (get-ffi-obj "viSScanf" visa-lib
               (_fun (vi : _uint32)
                     (buf : _string)
                     (readFmt : _string)
                     -> (ViStatus : _long))))

;; Returns a user-readable description of the status code passed to the operation.
(define vi-status-desc
  (get-ffi-obj "viStatusDesc" visa-lib
               (_fun (vi : _uint32)
                     (status : _int32)
                     (desc : (_ptr o _string))
                     -> (ViStatus : _long)
                     -> (values ViStatus desc))))

;; Requests a VISA session to terminate normal execution of an operation.
(define vi-terminate
  (get-ffi-obj "viTerminate" visa-lib
               (_fun (vi : _uint32)
                     (degree : _uint16)
                     (jobId : _long)
                     -> (ViStatus : _long))))

;; Uninstalls handlers for events.
(define vi-uninstall-handler
  (get-ffi-obj "viUninstallHandler" visa-lib
               (_fun (vi : _uint32)
                     (eventType : _long)
                     (handler : (_ptr i _void))
                     (userHandle : (_ptr i _void))
                     -> (ViStatus : _long))))

;; Relinquishes a lock for the specified resource.
(define vi-unlock
  (get-ffi-obj "viUnlock" visa-lib
               (_fun (vi : _uint32)
                     -> (ViStatus : _long))))

;; Unmaps memory space previously mapped by viMapAddress().
(define vi-unmap-address
  (get-ffi-obj "viUnmapAddress" visa-lib
               (_fun (vi : _uint32)
                     -> (ViStatus : _long))))

;; Undo a previous map from the specified trigger source line to the specified destination line.
(define vi-unmap-trigger
  (get-ffi-obj "viUnmapTrigger" visa-lib
               (_fun (vi : _uint32)
                     (trigSrc : _int16)
                     (trigDest : _int16)
                     -> (ViStatus : _long))))

;; Performs a USB control pipe transfer from the device.
(define vi-usb-control-in
  (get-ffi-obj "viUsbControlIn" visa-lib
               (_fun (vi : _uint32)
                     (bmRequestType : _int16)
                     (bRequest : _int16)
                     (wValue : _uint16)
                     (wIndex : _uint16)
                     (wLength : _uint16)
                     (buf : (_ptr o _string))
                     (retCnt : (_ptr o _uint16))
                     -> (ViStatus : _long)
                     -> (values ViStatus buf retCnt))))

;; Performs a USB control pipe transfer to the device.
(define vi-usb-control-out
  (get-ffi-obj "viUsbControlOut" visa-lib
               (_fun (vi : _uint32)
                     (bmRequestType : _int16)
                     (bRequest : _int16)
                     (wValue : _uint16)
                     (wIndex : _uint16)
                     (wLength : _uint16)
                     (buf : _string)
                     -> (ViStatus : _long))))

;; Converts, formats, and sends the parameters designated by params to the device or interface as specified by the format string.
(define vi-vprintf
  (get-ffi-obj "viVPrintf" visa-lib
               (_fun (vi : _uint32)
                     (writeFmt : _string)
                     (params : _pointer)
                     -> (ViStatus : _long))))

;; Performs a formatted write and read through a single call to an operation.
(define vi-vqueryf
  (get-ffi-obj "viVQueryf" visa-lib
               (_fun (vi : _uint32)
                     (writeFmt : _string)
                     (readFmt : _string)
                     (params : _pointer)
                     -> (ViStatus : _long))))


;; Reads, converts, and formats data using the format specifier. Stores the formatted data in the parameters designated by params.
(define vi-vscanf
  (get-ffi-obj "viVScanf" visa-lib
               (_fun (vi : _uint32)
                     (readFmt : _string)
                     (params : _pointer)
                     -> (ViStatus : _long))))

;; Converts, formats, and sends the parameters designated by params to a user-specified buffer as specified by the format string.
(define vi-vsprintf
  (get-ffi-obj "viVSPrintf" visa-lib
               (_fun (vi : _uint32)
                     (buf : (_ptr o _string))
                     (writeFmt : _string)
                     (params : _pointer)
                     -> (ViStatus : _long)
                     -> (values ViStatus buf))))

;; Reads, converts, and formats data from a user-specified buffer using the format specifier. Stores the formatted data in the parameters designated by params.
(define vi-vsscanf
  (get-ffi-obj "viVSScanf" visa-lib
               (_fun (vi : _uint32)
                     (buf : _string)
                     (readFmt : _string)
                     (params : _pointer)
                     -> (ViStatus : _long))))

;; Sends the device a miscellaneous command or query and/or retrieves the response to a previous query.
(define vi-vxi-command-query
  (get-ffi-obj "viVxiCommandQuery" visa-lib
               (_fun (vi : _uint32)
                     (mode : _uint16)
                     (cmd : _uint32)
                     (response : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus response))))

;; Waits for an occurrence of the specified event for a given session.
(define vi-wait-on-event
  (get-ffi-obj "viWaitOnEvent" visa-lib
               (_fun (vi : _uint32)
                     (inEventType : _long)
                     (timeout : _uint32)
                     (outEventType : (_ptr o _long))
                     (outContext : (_ptr o _long))
                     -> (ViStatus : _long)
                     -> (values ViStatus outEventType outContext))))

;; Writes data to device or interface synchronously.
(define vi-write
  (get-ffi-obj "viWrite" visa-lib
               (_fun (vi : _uint32)
                     (buf : _string)
                     (count : _uint32)
                     (retCount : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus retCount))))

;; Writes data to device or interface asynchronously.
(define vi-write-async
  (get-ffi-obj "viWriteAsync" visa-lib
               (_fun (vi : _uint32)
                     (buf : _string)
                     (count : _uint32)
                     (jobId : (_ptr o _long))
                     -> (ViStatus : _long)
                     -> (values ViStatus jobId))))

;; Take data from a file and write it out synchronously.
(define vi-write-from-file
  (get-ffi-obj "viWriteFromFile" visa-lib
               (_fun (vi : _uint32)
                     (fileName : _string)
                     (count : _uint32)
                     (retCount : (_ptr o _uint32))
                     -> (ViStatus : _long)
                     -> (values ViStatus retCount))))









