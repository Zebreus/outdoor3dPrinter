function stoi(string, pos = 0) = len(string)-pos > 0 ? 
    let(letter = string[len(string)-1-pos])
    ord(string[0])!=ord("-") ?
        (ord(letter)-ord("0") + stoi(string, pos+1)*10)
    : -stoi([for(i = [1:1:len(string)-1]) string[i]], pos)
: 0;

function stof(string, pos = 0) =
    string[0] == "-" ? -stof([for(i = [1:1:len(string)-1]) string[i] ]) :
    let (dot = search(".", [for(c = string) [c]])[0])
    let (firstPart = dot!=undef ? [for(i = [0:1:dot-1]) string[i] ] : string )
    let (secondPart = dot!=undef ? [for(i = [dot+1:1:len(string)-1]) string[i] ] : "" )
    stoi( firstPart ) + stoi( secondPart )/pow(10,len(secondPart));

module testMath(){
    echo("Testing string to number conversion functions");
    
    assert(stoi("25") == 25, "Error in stoi");
    assert(stoi("0") == 0, "Error in stoi");
    assert(stoi("") == 0, "Error in stoi");
    assert(stoi("-") == 0, "Error in stoi");
    assert(stoi("-0") == 0, "Error in stoi");
    assert(stoi("-25") == -25, "Error in stoi");    
    
    assert(stof("25") == 25, "Error in stof");
    assert(stof("25.00") == 25, "Error in stof");
    assert(stof("25.4") == 25.4, "Error in stof");
    assert(stof("25.410") == 25.41, "Error in stof");
    assert(stof("25.041") == 25.041, "Error in stof");
    assert(stof("-25.041") == -25.041, "Error in stof");
    assert(stof(".25") == 0.25, "Error in stof");
    assert(stof("-.25") == -0.25, "Error in stof");
    assert(stof(".") == 0, "Error in stof");
    assert(stof("-.") == 0, "Error in stof");
}

testMath();