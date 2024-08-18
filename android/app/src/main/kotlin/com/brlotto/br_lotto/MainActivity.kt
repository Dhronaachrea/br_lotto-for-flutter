package com.brlotto.br_lotto

import InvFlowResponseData
import android.annotation.SuppressLint
import android.os.Build
import android.util.Log
import android.widget.Toast
import com.common.apiutil.CommonException
import com.common.apiutil.printer.FontErrorException
import com.common.apiutil.printer.GateOpenException
import com.common.apiutil.printer.LowPowerException
import com.common.apiutil.printer.NoPaperException
import com.common.apiutil.printer.OverHeatException
import com.common.apiutil.printer.PaperCutException
import com.common.apiutil.printer.TimeoutException
import com.common.apiutil.printer.UsbThermalPrinter
import com.dcastalia.localappupdate.DownloadApk
import com.google.gson.Gson
import com.sunmi.peripheral.printer.InnerPrinterCallback
import com.sunmi.peripheral.printer.InnerPrinterException
import com.sunmi.peripheral.printer.InnerPrinterManager
import com.sunmi.peripheral.printer.InnerResultCallback
import com.sunmi.peripheral.printer.SunmiPrinterService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.Locale

class MainActivity: FlutterActivity() {

    private val mChannel            = "com.brlotto.br_lotto/test"
    private val mChannelForAppUpdate = "com.brlotto.br_lotto/loader_inner_bg"
    private val boldFontEnable      = byteArrayOf(0x1B, 0x45, 0x1)
    private val boldFontDisable     = byteArrayOf(0x1B, 0x45, 0x0)
    private lateinit var channel    : MethodChannel
    private lateinit var channel_app_update: MethodChannel
    private var mSunmiPrinterService: SunmiPrinterService? = null
    lateinit var downloadController: DownloadController

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initializeSunmiPrinter()

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mChannel)

        channel.setMethodCallHandler { call, result ->
            val argument            = call.arguments as Map<*, *>

            if(call.method == "invFlowPrint"){
                val invFlowResponse                              = argument["invFlowResponse"]
                val startDate                                    = argument["startDate"]
                val endDate                                      = argument["endDate"]
                val userName                                     = argument["name"]
                val showGameWiseOpeningBalanceData : Boolean     = argument["showGameWiseOpeningBalanceData"].toString().toBoolean()
                val showGameWiseClosingBalanceData : Boolean     = argument["showGameWiseClosingBalanceData"].toString().toBoolean()
                val showReceivedData : Boolean                   = argument["showReceivedData"].toString().toBoolean()
                val showReturnedData : Boolean                   = argument["showReturnedData"].toString().toBoolean()
                val showSoldData : Boolean                       = argument["showSoldData"].toString().toBoolean()
                val bookTicketLength                             = 8
                println("showGameWiseOpeningBalanceData: $showGameWiseOpeningBalanceData")
                println("showGameWiseOpeningBalanceData:type: ${showGameWiseOpeningBalanceData::class.java}")

                val invFlowResponseData  = Gson().fromJson(invFlowResponse.toString(), InvFlowResponseData::class.java)
                mSunmiPrinterService?.run {
                    enterPrinterBuffer(true)
                    setAlignment(1, null)
                    sendRAWData(boldFontEnable, null)
                    setFontSize(25f, null)
                    printText("Inventory Flow Report", null)
                    setFontSize(21f, null)
                    printText("\nDate $startDate To $endDate", null)
                    sendRAWData(boldFontDisable, null)
                    printText("\n____________________________\n", null)
                    printText("Organization name : $userName", null)
                    printText("\n____________________________\n", null)

                    sendRAWData(boldFontEnable, null)
                    printColumnsString(
                        arrayOf<String>(
                            "", "Books ","Tickets"
                        ),
                        intArrayOf(
                            bookTicketLength, bookTicketLength,bookTicketLength
                        ),
                        intArrayOf(0,2,2),
                        null
                    )
                    sendRAWData(boldFontDisable, null)

                    printColumnsString(
                        arrayOf<String>(
                            "OpenBalance ", "${invFlowResponseData.booksOpeningBalance} ","${invFlowResponseData.ticketsOpeningBalance}"
                        ),
                        intArrayOf(
                            "OpenBalance ".length, bookTicketLength, bookTicketLength
                        ),
                        intArrayOf(0,2,2),
                        null
                    )
                    printColumnsString(
                        arrayOf<String>(
                            "Received ", "${invFlowResponseData.receivedBooks} ","${invFlowResponseData.receivedTickets}"
                        ),
                        intArrayOf(
                            "Received ".length, bookTicketLength,bookTicketLength
                        ),
                        intArrayOf(0,2,2),
                        null
                    )
                    printColumnsString(
                        arrayOf<String>(
                            "Returned ", "${invFlowResponseData.returnedBooks} ","${invFlowResponseData.returnedTickets}"
                        ),
                        intArrayOf(
                            "Returned ".length, bookTicketLength,bookTicketLength
                        ),
                        intArrayOf(0,2,2),
                        null
                    )
                    printColumnsString(
                        arrayOf<String>(
                            "Sales ", "${invFlowResponseData.soldBooks} ","${invFlowResponseData.soldTickets}"
                        ),
                        intArrayOf(
                            "Sales ".length, bookTicketLength,bookTicketLength
                        ),
                        intArrayOf(0,2,2),
                        null
                    )
                    printColumnsString(
                        arrayOf<String>(
                            "Closing Balance ", "${invFlowResponseData.booksClosingBalance} ","${invFlowResponseData.ticketsClosingBalance}"
                        ),
                        intArrayOf(
                            "Closing Balance ".length, bookTicketLength,bookTicketLength
                        ),
                        intArrayOf(0,2,2),
                        null
                    )

                    printText("\n", null)

                    if(showGameWiseOpeningBalanceData){
                        sendRAWData(boldFontEnable, null)
                        printColumnsString(
                            arrayOf<String>(
                                "Open Balance ", "Books ","Tickets"
                            ),
                            intArrayOf(
                                "Open Balance ".length,bookTicketLength, bookTicketLength
                            ),
                            intArrayOf(0,2,2),
                            null
                        )
                        sendRAWData(boldFontDisable, null)

                        for(gameWiseOpeningData in invFlowResponseData.gameWiseOpeningBalanceData){
                            printColumnsString(
                                arrayOf<String>(
                                    gameWiseOpeningData.gameName + " ", "${gameWiseOpeningData.totalBooks} ","${gameWiseOpeningData.totalTickets}"
                                ),
                                intArrayOf(
                                    gameWiseOpeningData.gameName.length + 1, bookTicketLength, bookTicketLength
                                ),
                                intArrayOf(0,2,2),
                                null
                            )
                        }
                    }
                    printText("\n", null)

                    if(showReceivedData){
                        sendRAWData(boldFontEnable, null)
                        printColumnsString(
                            arrayOf<String>(
                                "Received ", "Books ","Tickets"
                            ),
                            intArrayOf(
                                "Received ".length, bookTicketLength,bookTicketLength
                            ),
                            intArrayOf(0,2,2),
                            null
                        )
                        sendRAWData(boldFontDisable, null)
                        for(gameWiseData in invFlowResponseData.gameWiseData){
                            printColumnsString(
                                arrayOf<String>(
                                    gameWiseData.gameName + " ", "${gameWiseData.receivedBooks} ","${gameWiseData.receivedTickets}"
                                ),
                                intArrayOf(
                                    gameWiseData.gameName.length + 1, bookTicketLength, bookTicketLength
                                ),
                                intArrayOf(0,2,2),
                                null
                            )
                        }
                    }
                    printText("\n", null)

                    if(showReturnedData){
                        sendRAWData(boldFontEnable, null)
                        printColumnsString(
                            arrayOf<String>(
                                "Returned ", "Books ","Tickets"
                            ),
                            intArrayOf(
                                "Returned ".length, bookTicketLength, bookTicketLength
                            ),
                            intArrayOf(0,2,2),
                            null
                        )
                        sendRAWData(boldFontDisable, null)
                        for(gameWiseData in invFlowResponseData.gameWiseData){
                            printColumnsString(
                                arrayOf<String>(
                                    gameWiseData.gameName + " ", "${gameWiseData.returnedBooks} ","${gameWiseData.returnedTickets}"
                                ),
                                intArrayOf(
                                    gameWiseData.gameName.length + 1, bookTicketLength, bookTicketLength
                                ),
                                intArrayOf(0,2,2),
                                null
                            )
                        }
                    }
                    printText("\n", null)

                    if(showSoldData){
                        sendRAWData(boldFontEnable, null)
                        printColumnsString(
                            arrayOf<String>(
                                "Sale ", "Books ","Tickets"
                            ),
                            intArrayOf(
                                "Sale ".length, bookTicketLength, bookTicketLength
                            ),
                            intArrayOf(0,2,2),
                            null
                        )
                        sendRAWData(boldFontDisable, null)
                        for(gameWiseData in invFlowResponseData.gameWiseData){
                            printColumnsString(
                                arrayOf<String>(
                                    gameWiseData.gameName + " ", "${gameWiseData.soldBooks} ","${gameWiseData.soldTickets}"
                                ),
                                intArrayOf(
                                    gameWiseData.gameName.length + 1, bookTicketLength, bookTicketLength
                                ),
                                intArrayOf(0,2,2),
                                null
                            )
                        }
                    }
                    printText("\n", null)

                    if(showGameWiseClosingBalanceData){
                        sendRAWData(boldFontEnable, null)
                        printColumnsString(
                            arrayOf<String>(
                                "Closing Balance ", "Books ","Tickets"
                            ),
                            intArrayOf(
                                "Closing Balance ".length, bookTicketLength, bookTicketLength
                            ),
                            intArrayOf(0,2,2),
                            null
                        )
                        sendRAWData(boldFontDisable, null)

                        for(gameWiseClosingData in invFlowResponseData.gameWiseClosingBalanceData){
                            printColumnsString(
                                arrayOf<String>(
                                    gameWiseClosingData.gameName + " ", "${gameWiseClosingData.totalBooks} ","${gameWiseClosingData.totalTickets}"
                                ),
                                intArrayOf(
                                    gameWiseClosingData.gameName.length + 1, bookTicketLength, bookTicketLength),
                                intArrayOf(0,2,2),
                                null
                            )
                        }
                    }
                    printText("\n------ FOR DEMO ------\n\n", null)
                    exitPrinterBufferWithCallback(true, object : InnerResultCallback() {
                        override fun onRunResult(isSuccess: Boolean) {}

                        override fun onReturnString(result: String?) {}

                        override fun onRaiseException(code: Int, msg: String?) {
                            activity.runOnUiThread { Toast.makeText(activity, "Something went wrong while printing, Please try again", Toast.LENGTH_SHORT).show() }
                            result.error("-1", msg, "Something went wrong while printing")
                        }

                        override fun onPrintResult(code: Int, msg: String?) {
                            if(updatePrinterState() != 1) {
                                activity.runOnUiThread { Toast.makeText(activity, "Something went wrong while printing, Please try again", Toast.LENGTH_SHORT).show() }
                                result.error("-1", msg, "Something went wrong while printing")

                            } else {
                                activity.runOnUiThread { Toast.makeText(activity, "Successfully printed", Toast.LENGTH_SHORT).show() }
                                result.success(true)
                            }
                        }
                    })

                } ?: this.let {
                    val usbThermalPrinter = UsbThermalPrinter(activity.baseContext)
                    if(getDeviceName() == "QUALCOMM M1") {
                        usbThermalPrinter.run {
                            try {
                                reset()
                                start(1)
                                setTextSize(25)
                                addString("")
                                setBold(true)
                                setGray(1)
                                setAlgin(1)
                                addString("Inventory Flow Report")
                                setTextSize(21)
                                setBold(false)
                                addString("Date $startDate To $endDate")
                                setBold(false)
                                addString(printLineStringData(getPaperLength()))
                                addString("Organization name : $userName")
                                addString(printLineStringData(getPaperLength()))
                                addString("\n")
                                setBold(true)
                                addString(printThreeStringData("        ", "Books", "Tickets"))
                                setBold(false)
                                addString(printThreeStringData("OpenBalance", "${invFlowResponseData.booksOpeningBalance}","${invFlowResponseData.ticketsOpeningBalance}"))
                                addString(printThreeStringData("Received", "${invFlowResponseData.receivedBooks}","${invFlowResponseData.receivedTickets}"))
                                addString(printThreeStringData( "Returned", "${invFlowResponseData.returnedBooks}","${invFlowResponseData.returnedTickets}"))
                                addString(printThreeStringData( "Sales", "${invFlowResponseData.soldBooks}","${invFlowResponseData.soldTickets}"))
                                addString(printThreeStringData( "Closing Balance", "${invFlowResponseData.booksClosingBalance}","${invFlowResponseData.ticketsClosingBalance}"))
                                if(showGameWiseOpeningBalanceData){
                                    addString("\n")
                                    setBold(true)
                                    addString(printThreeStringData( "Open Balance ", "Books ","Tickets"))
                                    setBold(false)
                                    for(gameWiseOpeningData in invFlowResponseData.gameWiseOpeningBalanceData) {
                                        addString(
                                            printThreeStringData(
                                                gameWiseOpeningData.gameName, "${gameWiseOpeningData.totalBooks}","${gameWiseOpeningData.totalTickets}"
                                            )
                                        )
                                    }
                                }
                                if(showReceivedData){
                                    addString("\n")
                                    setBold(true)
                                    addString(printThreeStringData( "Received ", "Books ","Tickets"))
                                    setBold(false)
                                    for(gameWiseData in invFlowResponseData.gameWiseData) {
                                        addString(
                                            printThreeStringData(
                                                gameWiseData.gameName, "${gameWiseData.receivedBooks} ","${gameWiseData.receivedTickets}"
                                            )
                                        )
                                    }
                                }
                                if(showReturnedData){
                                    addString("\n")
                                    setBold(true)
                                    addString(printThreeStringData( "Returned ", "Books ","Tickets"))
                                    setBold(false)
                                    for(gameWiseData in invFlowResponseData.gameWiseData) {
                                        addString(
                                            printThreeStringData(
                                                gameWiseData.gameName, "${gameWiseData.returnedBooks} ","${gameWiseData.returnedTickets}"
                                            )
                                        )
                                    }
                                }
                                if(showSoldData){
                                    addString("\n")
                                    setBold(true)
                                    addString(printThreeStringData( "Sale ", "Books ","Tickets"))
                                    setBold(false)
                                    for(gameWiseData in invFlowResponseData.gameWiseData) {
                                        addString(
                                            printThreeStringData(
                                                gameWiseData.gameName, "${gameWiseData.soldBooks} ","${gameWiseData.soldTickets}"
                                            )
                                        )
                                    }
                                }
                                if(showGameWiseClosingBalanceData){
                                    addString("\n")
                                    setBold(true)
                                    addString(printThreeStringData( "Closing Balance ", "Books ","Tickets"))
                                    setBold(false)
                                    for(gameWiseClosingData in invFlowResponseData.gameWiseClosingBalanceData) {
                                        addString(
                                            printThreeStringData(
                                                gameWiseClosingData.gameName, "${gameWiseClosingData.totalBooks} ","${gameWiseClosingData.totalTickets}"
                                            )
                                        )
                                    }
                                }
                                addString("\n")
                                addString("----- FOR DEMO -----")
                                addString("\n")
                                printString()
                                activity.runOnUiThread { Toast.makeText(activity, "Successfully printed", Toast.LENGTH_SHORT).show() }
                                result.success(true)
                            } catch (e : java.lang.Exception) {
                                showMsgAccordingToException(e as CommonException, result)
                                stop()
                                e.printStackTrace()
                            }
                        }

                    } else {
                        android.util.Log.d("TAg", "configureFlutterEngine: -----------")
                        result.error("-1", "Unable to find printer", "no sunmi or no usb thermal printer")
                    }
                }
            }
        }

        channel_app_update = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mChannelForAppUpdate)

        channel_app_update.setMethodCallHandler { call, result ->
            val argument = call.arguments!! as Map<*,*>;
            val downloadUrl = argument["url"]
            downloadController = DownloadController(activity, downloadUrl.toString())

            if (call.method == "_downloadUpdatedAPK") {
                Log.d("TaG", "url----->$downloadUrl")
                val downloadApk = DownloadApk(activity)
                downloadApk.startDownloadingApk(downloadUrl.toString(), "br_lotto_updated" + System.currentTimeMillis() + ".apk")
                //downloadController.enqueueDownload()
                //val downloadController = downloadController.enqueueDownload()
                /*if (downloadController) {
                    result.error("-1", "Unable to download, Please try after some time.", "")
                }*/
            }
        }
    }

    private fun showMsgAccordingToException(exception: CommonException,  result : MethodChannel.Result) {

        when(exception) {
            is NoPaperException -> result.error("-1", "Please insert the paper before printing", "${exception.message}")
            is OverHeatException -> result.error("-1", "Device overheated, Please try after some time.", "${exception.message}")
            is GateOpenException -> result.error("-1", "Something went wrong while printing", "${exception.message}")
            is PaperCutException -> result.error("-1", "Something went wrong while printing", "${exception.message}")
            is TimeoutException -> result.error("-1", "Unable to print, Please try after some time.", "${exception.message}")
            is FontErrorException -> result.error("-1", "Something went wrong while printing", "${exception.message}")
            is LowPowerException -> result.error("-1", "Low battery, Please charge the device !", "${exception.message}")
            else                    -> result.error("-1", "Something went wrong while printing", "${exception.message}")

        }
    }

    private fun capitalize(s: String?): String {
        if (s == null || s.isEmpty()) {
            return ""
        }
        val first = s[0]
        return if (Character.isUpperCase(first)) {
            s
        } else {
            first.uppercaseChar().toString() + s.substring(1)
        }
    }

    private fun getDeviceName(): String {
        val manufacturer = Build.MANUFACTURER
        val model = Build.MODEL
        return if (model.lowercase(Locale.getDefault()).startsWith(
                manufacturer.lowercase(
                    Locale.getDefault()
                )
            )
        ) {
            capitalize(model)
        } else {
            if (model.equals("T2mini_s", ignoreCase = true)
            ) capitalize(manufacturer) + " T2mini" else capitalize(manufacturer) + " " + model
        }
    }

    private fun initializeSunmiPrinter() {
        try {
            InnerPrinterManager.getInstance().bindService(this, innerPrinterCallback)
        } catch (e: InnerPrinterException) {
            e.printStackTrace()
        }
    }

    private var innerPrinterCallback: InnerPrinterCallback = object : InnerPrinterCallback() {
        override fun onConnected(sunmiPrinterService: SunmiPrinterService) {
            mSunmiPrinterService = sunmiPrinterService
        }

        override fun onDisconnected() {}
    }

    @SuppressLint("SimpleDateFormat")
    fun getFormattedDate(sourceDate: String) : String {
        val input   = SimpleDateFormat("dd-MM-yyyy")
        val output  = SimpleDateFormat("MMM dd, yyyy")
        try {
            input.parse(sourceDate)?.let {
                return output.format(it)
            }
        } catch (e: Exception) {
            Log.e("log", "Date parsing error: ${e.message}")
        }
        return sourceDate
    }

    @SuppressLint("SimpleDateFormat")
    fun getFormattedTime(sourceTime: String) : String {
        val input   = SimpleDateFormat("HH:mm:ss")
        val output  = SimpleDateFormat("HH:mm:ss")
        try {
            input.parse(sourceTime)?.let {
                return output.format(it)
            }
        } catch (e: Exception) {
            Log.e("log", "Date parsing error: ${e.message}")
        }
        return sourceTime
    }

    private fun getPaperLength(): Int {
        return "--------------------------".length
    }

    private fun printDashStringData(length: Int): String {
        val str = StringBuffer()
        for( i in 0..length) {
            str.append("-")
        }
        return str.toString()
    }

    private fun printLineStringData(length: Int): String {
        val str = StringBuffer()
        for( i in 0..length) {
            str.append("_")
        }
        return str.toString()
    }

    private fun printTwoStringStringData(one: String, two: String): String {
        val str = StringBuffer()
        val spaceInBetween = getPaperLength() - (one.length + two.length)
        Log.d("TAg", "printTwoStringStringData: $spaceInBetween")
        str.append(one)
        for( i in 0..spaceInBetween) {
            str.append("  ")
        }
        str.append(two)
        return str.toString()
    }
    private fun printThreeStringData(one: String, two: String,three: String): String {
        val str = StringBuffer()
        val spaceInBetween = (getPaperLength() - (one.length + two.length + three.length)) / 2
        Log.d("TAg", "printTwoStringStringData: $spaceInBetween")
        str.append(one)
        for( i in 0..spaceInBetween) {
            str.append("  ")
        }
        str.append(two)
        for( i in 0..spaceInBetween) {
            str.append("  ")
        }
        str.append(three)
        return str.toString()
    }

}