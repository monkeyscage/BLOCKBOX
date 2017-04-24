contract universalBox{
address public owner; //standard needed for Alpha Layer and generic augmentation
address public controller; //allowed to post, share and edit logs
string standard="BLOCKBOX.1.0";  //the blog standard
uint public logcount;
uint public totExposed;
 
//creation
function universalBox(address o) {
owner=o;
logcount=1;
totExposed=1;
logs.push(log(o,block.number,0,1));
}

//change owner
function manager(address o)returns(bool){
if(msg.sender!=owner)throw;
owner=o;
return true;
}

//change owner
function setController(address o)returns(bool){
if(msg.sender!=owner)throw;
controller=o;
return true;
}
 
//add a new post at the end of the log
function addEntity(address ethEntity) returns(bool){
if((msg.sender!=owner)&&(msg.sender!=controller))throw;
logs.push(log(ethEntity,block.number,logcount-1,logcount+1));
logcount++;
totExposed++;
return true;
}



//delete a specific post at a given index
function deleteEntity(uint index) returns(bool){
if((msg.sender!=owner)&&(msg.sender!=controller))throw;
log l=logs[index];
logs[l.prev].next=l.next;
logs[l.next].prev=l.prev;
totExposed--;
return true;
}
 
//read the logs by index
function readLog(uint i)constant returns(uint,address,uint,uint,uint,uint){
log l=logs[i];
return(logs.length,l.ethlink,l.blocknumber,l.prev,l.next,totExposed);
}

//the logs container
log[] logs;
//used to know in advance the logs structure
string public logInterface="a-Log|u-Block|u-PrevLog|u-NextLog|u-TotExposed";

    struct log{
    address ethlink;
    uint blocknumber;
    uint prev;
    uint next;
   }
 
 
//destroy blog
function kill(){
if (msg.sender != owner)throw;
selfdestruct(owner);
}
 
}
