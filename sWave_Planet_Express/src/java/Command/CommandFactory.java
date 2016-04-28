package Command;

/**
 *
 * @author Austin
 */
public class CommandFactory {
    public Command createCommand(String action) {
        Command command = null;

        if ( action.equalsIgnoreCase("login") ) {
            //Logging a user in and storing in the session
            command = new LoginCommand();
        } else if ( action.equalsIgnoreCase("register") ) {
            //Register is the command for registering a user and adding him to the database
            command = new RegisterCommand();
        } else if ( action.equalsIgnoreCase("logout") ) {
            //Logs out the user by invalidating the session and returns to the home page
            command = new LogoutCommand();
        } else if ( action.equalsIgnoreCase("createTicket") ) {
            //Creates ticket
            command = new CreateTicketCommand();
        } else if ( action.equalsIgnoreCase("closeTicket") ) {
            //Closes ticket
            command = new CloseTicketCommand();
        } else if ( action.equalsIgnoreCase("upload") ) {
            //Allows Song Uploading
            command = new UploadCommand();
        } else if ( action.equalsIgnoreCase("uploadUserPicture") ) {
            //Allows Picture Uploading
            command = new UploadUserPictureCommand();
        } else if ( action.equalsIgnoreCase("loadUserPicture") ) {
            //Allows Picture Loading
            command = new LoadUserPictureCommand();
        } else if ( action.equalsIgnoreCase("search") ) {
            //For searching for songs
            command = new SearchCommand();
        } else if ( action.equalsIgnoreCase("deleteSong") ) {
            //Deleting a song from the database
            command = new DeleteSongCommand();
        } else if ( action.equalsIgnoreCase("changeSkin") ) {
            //Allows the user to change the look of sWave
            command = new ChangeSkinCommand();
        } else if ( action.equalsIgnoreCase("checkout") ) {
            //Checking out the cart
            command = new CheckoutCommand();
        } else if ( action.equalsIgnoreCase("updateDetails") ) {
            //Updating the users details
            command = new UpdateDetailsCommand();
        } else if ( action.equalsIgnoreCase("addSongToCart") ) {
            //Adding a song to the cart
            command = new AddSongToCartCommand();
        } else if ( action.equalsIgnoreCase("addMerchToCart") ) {
            //Adding a merch item to the cart
            command = new AddMerchToCartCommand();
        } else if ( action.equalsIgnoreCase("deletePlaylist") ) {
            //Deleting a playlist
            command = new DeletePlaylistCommand();
        } else if ( action.equalsIgnoreCase("createPlaylist") ) {
            //Creating a playlist
            command = new CreatePlaylistCommand();
        } else if ( action.equalsIgnoreCase("loadArtwork") ) {
            //Load Album Artwork
            command = new LoadArtworkCommand();
        } else if ( action.equalsIgnoreCase("stream") ) {
            //Begin Stream using Next Gen Streaming System ;)
            command = new StreamCommand();
        } else if ( action.equalsIgnoreCase("songInfoDisplay") ) {
            //Used to display song info after streaming has begun
            command = new SongInfoDisplayCommand();
        } else if ( action.equalsIgnoreCase("addSongToPlaylist") ) {
            //Adding a song to a playlist
            command = new AddSongToPlaylistCommand();
        } else if ( action.equalsIgnoreCase("deleteFromPlaylist") ) {
            //Deleting a song from a playlist
            command = new DeleteFromPlaylistCommand();
        } else if ( action.equalsIgnoreCase("moveSongInPlaylist") ) {
            //Moving a song up or down in a playlist
            command = new MoveSongInPlaylistCommand();
        } else if ( action.equalsIgnoreCase("editSong") ) {
            //Editing a song
            command = new EditSongCommand();
        }else if ( action.equalsIgnoreCase("requestFriend") ) {
            //Editing a song
            command = new RequestFriendCommand();
        } else if ( action.equalsIgnoreCase("ConfirmFriend") ) {
            //Editing a song
            command = new ConfirmFriendCommand();
        } else if ( action.equalsIgnoreCase("removeFriend") ) {
            //Editing a song
            command = new RemoveFriendCommand();
        } else if ( action.equalsIgnoreCase("sendMessage") ) {
            //Send a Message to a Friend
            command = new SendMessageCommand();
        } else {
            command = new DummyCommand();
        }
        return command;
    }
}
