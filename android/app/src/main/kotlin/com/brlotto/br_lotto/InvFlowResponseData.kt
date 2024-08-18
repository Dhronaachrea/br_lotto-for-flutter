
import com.google.gson.annotations.SerializedName

data class InvFlowResponseData(
    @SerializedName("booksClosingBalance")
    val booksClosingBalance: Int,
    @SerializedName("booksOpeningBalance")
    val booksOpeningBalance: Int,
    @SerializedName("gameWiseClosingBalanceData")
    val gameWiseClosingBalanceData: List<GameWiseClosingBalanceData>,
    @SerializedName("gameWiseData")
    val gameWiseData: List<GameWiseData>,
    @SerializedName("gameWiseOpeningBalanceData")
    val gameWiseOpeningBalanceData: List<GameWiseOpeningBalanceData>,
    @SerializedName("receivedBooks")
    val receivedBooks: Int,
    @SerializedName("receivedTickets")
    val receivedTickets: Int,
    @SerializedName("responseCode")
    val responseCode: Int,
    @SerializedName("responseMessage")
    val responseMessage: String,
    @SerializedName("returnedBooks")
    val returnedBooks: Int,
    @SerializedName("returnedTickets")
    val returnedTickets: Int,
    @SerializedName("soldBooks")
    val soldBooks: Int,
    @SerializedName("soldTickets")
    val soldTickets: Int,
    @SerializedName("ticketsClosingBalance")
    val ticketsClosingBalance: Int,
    @SerializedName("ticketsOpeningBalance")
    val ticketsOpeningBalance: Int
) {
    data class GameWiseClosingBalanceData(
        @SerializedName("gameId")
        val gameId: Int,
        @SerializedName("gameName")
        val gameName: String,
        @SerializedName("gameNumber")
        val gameNumber: Int,
        @SerializedName("totalBooks")
        val totalBooks: Int,
        @SerializedName("totalTickets")
        val totalTickets: Int
    )

    data class GameWiseData(
        @SerializedName("gameId")
        val gameId: Int,
        @SerializedName("gameName")
        val gameName: String,
        @SerializedName("gameNumber")
        val gameNumber: Int,
        @SerializedName("missingBooks")
        val missingBooks: Int,
        @SerializedName("missingTickets")
        val missingTickets: Int,
        @SerializedName("receivedBooks")
        val receivedBooks: Int,
        @SerializedName("receivedTickets")
        val receivedTickets: Int,
        @SerializedName("returnedBooks")
        val returnedBooks: Int,
        @SerializedName("returnedTickets")
        val returnedTickets: Int,
        @SerializedName("soldBooks")
        val soldBooks: Int,
        @SerializedName("soldTickets")
        val soldTickets: Int
    )

    data class GameWiseOpeningBalanceData(
        @SerializedName("gameId")
        val gameId: Int,
        @SerializedName("gameName")
        val gameName: String,
        @SerializedName("gameNumber")
        val gameNumber: Int,
        @SerializedName("totalBooks")
        val totalBooks: Int,
        @SerializedName("totalTickets")
        val totalTickets: Int
    )
}