contract boxIndex{
address public owner;
address public controller;

address[] public boxes;

mapping(address => address[]) myboxes;
 
function boxIndex(){owner=msg.sender;}
function setOwner(address NewOwner){if(msg.sender!=owner)throw;owner=NewOwner;}
function setController(address NewController){if(msg.sender!=owner)throw;controller=NewController;}
function addBox(address BoxAddress,address creator)returns(bool){if(msg.sender!=controller)throw;myboxes[creator].push(BoxAddress);blogs.push(BoxAddress);return true;}
function removeBox(uint index){if(msg.sender!=owner)throw;boxes[index]=0x0;}
function getBox(uint index)constant returns(uint,address){uint t=boxes.length; return(t,boxes[index]);}
function getMyBox(address creator,uint index)constant returns(uint,address){uint t=myboxes[creator].length; return(t,myboxes[creator][index]);}
}

contract BOXgenerator{
AlphaLayer alpha;
address public owner; //standard needed for Alpha Layer and generic augmentation
logsIndex logsindex;
mapping(address => address)public lastBoxGenerated;
//creation
function BOXgenerator(address mainindex,address alph) {
boxindex=boxIndex(mainindex);
owner=msg.sender;
alpha=AlphaLayer(alph);
}

 
//generate new BLOCKbox
function generateBLOCKBOX() returns(bool){
address b;
universalBox box;



   b=new universalBox(this);
   alpha.addString(this,b,1000,"UniversalBox");
   box=universalBox(b);
   box.manager(msg.sender);




if(!boxindex.addBox(b,msg.sender))throw;

logs.push(log(b,block.number));

lastBoxGenerated[msg.sender]=b;

return true;
}

//read the logs by index
function readLog(uint i)constant returns(uint,address,uint){
log l=logs[i];
return(logs.length,l.ethlink,l.blocknumber);
}

//the logs container
log[] logs;
//used to know in advance the logs structure
string public logInterface="a-Log|u-Block";

    struct log{
    address ethlink;
    uint blocknumber;
   }
 
//destroy generator
function kill(){
if (msg.sender != owner)throw;
selfdestruct(owner);
}
 
 
}



contract AlphaLayer{
function addString(address d,address addr,uint index,string info) returns(bool){
   return true;
}
}

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
 
 
//destroy box
function kill(){
if (msg.sender != owner)throw;
selfdestruct(owner);
}
 
}
