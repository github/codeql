function bad1() {
	if (cond())
		f();
		g();
}

function good1() {
	if (cond()) {
		f();
	}
		g();
}

function good2() {
	if (cond())
		f();
	g();
}

function bad2() {
	if (cond())
		f();
	else
		g();
		h();
}

function good3() {
  if (cond())
		f();
  g();
}

function wbad1() {
	while (cond())
		f();
		g();
}

function wgood1() {
	while (cond()) {
		f();
	}
		g();
}

function wgood2() {
	while (cond())
		f();
	g();
}

function wgood3() {
  while (cond())
		f();
  g();
}

function dgood() {
	do
		f();
	while (false);
		g();
}

function tgood() {
	try {
		if (cond())
			throw new Error();
	} finally {}
		f();
}

function good4() {
	if (cond())
	f();
	g();
}

function good5() {
    try {
    } catch (e) {
    }
}

function good6() {
    try {
    } catch (e) {
    };
}

function good7() {
    if (e) {
        try {
        } catch (e) {
        }
    }
}

function good8() {
    if (e) {
        try {
        } catch (e) {
        };
    }
}

function good9() {
    if(e){
        try{
        } catch(e){
        };
    }
}

function good10() {
    if(e){
        try{
        }catch(e){
        };
    }
}
