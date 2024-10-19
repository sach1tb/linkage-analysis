const canvas = document.getElementById('canvas');
//const theta3 = document.getElementById('theta3');
const ctx = canvas.getContext('2d');

const cs_canvas = document.getElementById('cs_canvas');
const cs_ctx = cs_canvas.getContext('2d');


// Flip the y-axis
//ctx.scale(1, -1);
//ctx.transform(1, 0, 0, -1, 0, canvas.height)

// Get slider elements
// fourbar
const groundSlider = document.getElementById('ground');
const couplerSlider = document.getElementById('coupler');
const APSlider = document.getElementById('APlen');
const BAPSlider = document.getElementById('BAPAngle');
const outputSlider = document.getElementById('output');
const crankSlider = document.getElementById('crank');
const crankAngleSlider = document.getElementById('crankA');
const groundAngleSlider = document.getElementById('groundA');
const configCheckbox = document.getElementById('config');
//const playButton = document.getElementById('playButton');

// crank slider
const cs_couplerSlider = document.getElementById('cs_coupler');
const cs_crankSlider = document.getElementById('cs_crank');
const cs_offsetSlider = document.getElementById('cs_offset');
const cs_crankAngleSlider = document.getElementById('cs_crankA');
const cs_configCheckbox = document.getElementById('cs_config');

// fourbar
//let isPlaying = false;
let ground_angle = groundAngleSlider.value*Math.PI/180; // Starting angle for the rotation
let crank_angle = crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation

// crank slider
let cs_crank_angle = cs_crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation


// Display initial values
// fourbar
document.getElementById('groundLength').innerText = groundSlider.value;
document.getElementById('couplerLength').innerText = couplerSlider.value;
document.getElementById('APLength').innerText = APSlider.value;
document.getElementById('BAP').innerText = BAPSlider.value;
document.getElementById('outputLength').innerText = outputSlider.value;
document.getElementById('crankLength').innerText = crankSlider.value;
document.getElementById('crankAngleSlider').innerText = crankAngleSlider.value;
document.getElementById('groundAngleSlider').innerText = groundAngleSlider.value;

// crank slider
document.getElementById('cs_couplerLength').innerText = cs_couplerSlider.value;
document.getElementById('cs_crankLength').innerText = cs_crankSlider.value;
document.getElementById('cs_offsetHeight').innerText = cs_offsetSlider.value;
document.getElementById('cs_crankAngleSlider').innerText = cs_crankAngleSlider.value;


// Event listeners to update the display and redraw
// fourbar
groundSlider.oninput = () => updateDisplay(groundSlider, 'groundLength');
couplerSlider.oninput = () => updateDisplay(couplerSlider, 'couplerLength');
APSlider.oninput = () => updateDisplay(APSlider, 'APLength');
BAPSlider.oninput = () => updateDisplay(BAPSlider, 'BAP');
outputSlider.oninput = () => updateDisplay(outputSlider, 'outputLength');
crankSlider.oninput = () => updateDisplay(crankSlider, 'crankLength');
crankAngleSlider.oninput = () => updateDisplay(crankAngleSlider, 'crankAngleSlider');
groundAngleSlider.oninput = () => updateDisplay(groundAngleSlider, 'groundAngleSlider');

// crank slider
cs_crankSlider.oninput = () => updateDisplay(cs_crankSlider, 'cs_crankLength');
cs_offsetSlider.oninput = () => updateDisplay(cs_offsetSlider, 'cs_offsetHeight');
cs_crankAngleSlider.oninput = () => updateDisplay(cs_crankAngleSlider, 'cs_crankAngleSlider');
cs_couplerSlider.oninput = () => updateDisplay(cs_couplerSlider, 'cs_couplerLength');

// configuration change
// fourbar
config.addEventListener("change", function() {
    drawFourBar();
  });

// crank slider
cs_config.addEventListener("change", function() {
    drawCrankSlider();
  });

// playButton.onclick = () => {
//     isPlaying = !isPlaying;
//     playButton.innerText = isPlaying ? 'Pause' : 'Play';
//     if (isPlaying) {
//         animate();
//     }
// };

function openPage(pageName, elmnt) {
    // Hide all elements with class="tabcontent" by default */
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
  
    // Remove the background color of all tablinks/buttons
    // tablinks = document.getElementsByClassName("tablink");
    //for (i = 0; i < tablinks.length; i++) {
    //  tablinks[i].style.backgroundColor = "";
    //}
  
    // Show the specific tab content
    document.getElementById(pageName).style.display = "block";
  
  }
  
  // Get the element with id="defaultOpen" and click on it
  document.getElementById("defaultOpen").click();

function updateDisplay(slider, valueId) {
    document.getElementById(valueId).innerText = slider.value;
    drawFourBar();
    drawCrankSlider();
}

function fourbar_position(a,b,c,d,t2,t1,cfg) {
    const K1=2*d*c*Math.cos(t1)-2*a*c*Math.cos(t2);
    const K2=2*d*c*Math.sin(t1)-2*a*c*Math.sin(t2);
    const K3=2*a*d*Math.sin(t1)*Math.sin(t2) + 2*a*d*Math.cos(t1)*Math.cos(t2);
    const K4=b**2-a**2-c**2-d**2;
    
    const A=K4+K1+K3;
    const B=-2*K2;
    const C=K4-K1+K3;

    const t4c=2*Math.atan((-B-Math.sqrt(B**2-4*A*C))/(2*A));
    const t4o=2*Math.atan((-B+Math.sqrt(B**2-4*A*C))/(2*A));

    const K5=2*a*b*Math.cos(t2)-2*b*d*Math.cos(t1);
    const K6=2*a*b*Math.sin(t2)-2*b*d*Math.sin(t1);
    const K7=2*a*d*Math.sin(t1)*Math.sin(t2) + 2*a*d*Math.cos(t1)*Math.cos(t2);
    const K8=(c**2-d**2-a**2-b**2);


    const D=K8+K7+K5;
    const E=-2*K6;
    const F=K8-K5+K7;

   
    const t3c=2*Math.atan((-E+Math.sqrt(E**2-4*D*F))/(2*D));
    const t3o=2*Math.atan((-E-Math.sqrt(E**2-4*D*F))/(2*D));

    if (cfg==1) {
        t3=t3o;
        t4=t4o;
    } else {
        t3=t3c;
        t4=t4c;
    }
    return [t3, t4]
}

function cs_position(a,b,c,t2,cfg){
    t31=Math.asin((a*Math.sin(t2)-c)/b);
    t32=Math.PI-t31;
    if (cfg==1) {
        t3=t31;
    } else {
        t3=t32;
    }
    d=a*Math.cos(t2)-b*Math.cos(t3);
    return [t3, d]
}

function drawCouplerCurve(){
    const ground = parseInt(groundSlider.value);
    const coupler = parseInt(couplerSlider.value);
    const output = parseInt(outputSlider.value);
    const crank = parseInt(crankSlider.value);

    // Fixed point (Z)
    const Z= { x: 100, y: 100 };
    let cfg=0;
    if (configCheckbox.checked) {
        cfg=1;
    }
    for (var t2 = 0; t2 < 500; t2++)
        {
            const angles=fourbar_position(crank,coupler,output,ground,
                t2*2*Math.PI/500,ground_angle,cfg)
            const P = {
                    x: Z.x + crank * Math.cos(t2) + APSlider.value * Math.cos(BAPSlider.value*Math.PI/180+angles[0]),
                    y: Z.y + crank * Math.sin(t2) + APSlider.value * Math.sin(BAPSlider.value*Math.PI/180+angles[0])
            };
            P.y=canvas.height-P.y;
            ctx.fillRect(P.x,P.y,1,1);
        }
}

function drawFourBar() {
    const ground = parseInt(groundSlider.value);
    const coupler = parseInt(couplerSlider.value);
    const output = parseInt(outputSlider.value);
    const crank = parseInt(crankSlider.value);
    let crank_angle = crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation
    let ground_angle = groundAngleSlider.value*Math.PI/180; // Starting angle for the rotation

    //if (animate){
    //    const crank_angle = parseInt(crankAngleSlider.value)*Math.PI/180;
    //}
    // Clear the canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    //drawCouplerCurve();

    // Fixed point (Z)
    const Z= { x: 100, y: 100 };

    const Y = { x: Z.x + ground * Math.cos(ground_angle), 
        y: Z.y+ ground * Math.sin(ground_angle) }; // ground

    // Calculate positions for the four-bar linkage
    let cfg=0;
    if (configCheckbox.checked) {
        cfg=1;
    }
    const angles=fourbar_position(crank,coupler,output,ground,
        crank_angle,ground_angle,cfg)
    const coupler_angle = angles[0];
    const output_angle = angles[1];

    const A = {
        x: Z.x + crank * Math.cos(crank_angle),
        y: Z.y + crank * Math.sin(crank_angle)
    };

    const B = {
        x: A.x + coupler * Math.cos(coupler_angle),
        y: A.y + coupler * Math.sin(coupler_angle)
    };

    const P = {
        x: A.x + APSlider.value * Math.cos(BAPSlider.value*Math.PI/180+coupler_angle),
        y: A.y + APSlider.value * Math.sin(BAPSlider.value*Math.PI/180+coupler_angle)
    };

    A.y=canvas.height-A.y;
    B.y=canvas.height-B.y;
    Z.y=canvas.height-Z.y;
    Y.y=canvas.height-Y.y;
    P.y=canvas.height-P.y;

    // Draw the links
    // Draw the ground.
    ctx.beginPath();
    ctx.moveTo(Z.x, Z.y);
    ctx.strokeStyle = '#000000';
    ctx.lineTo(Y.x, Y.y);
    ctx.stroke();

    // Draw the crank.
    ctx.beginPath();
    ctx.moveTo(Z.x, Z.y);
    ctx.strokeStyle = '#FF0000';
    ctx.lineTo(A.x, A.y);
    ctx.stroke();

    // Draw the coupler.
    ctx.beginPath();
    ctx.moveTo(A.x, A.y);
    ctx.strokeStyle = "#00FF00";
    ctx.lineTo(B.x, B.y);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(A.x, A.y);
    ctx.strokeStyle = "#00FF00";
    ctx.lineTo(P.x, P.y);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(P.x, P.y);
    ctx.strokeStyle = "#00FF00";
    ctx.lineTo(B.x, B.y);
    ctx.stroke();
    
    // Draw the output.
    ctx.beginPath();
    ctx.moveTo(Y.x, Y.y);
    ctx.strokeStyle = "#0000FF";
    ctx.lineTo(B.x, B.y);
    ctx.stroke();

    // Draw the points
    drawGround(Z, "rgb(0,0,0,0.5", ctx);
    drawGround(Y, "rgb(0,0,0,0.5", ctx);
    drawPinJoint(Z,ctx);
    drawPinJoint(Y,ctx);
    drawPinJoint(B, ctx);
    drawPinJoint(A, ctx);


    // show the points
    ctx.fillText('Z', Z.x*0.95, Z.y*1.05)
    ctx.fillText('Y', Y.x*1.05, Y.y*1.05)
    ctx.fillText('B', B.x*1.05, B.y*0.95)
    ctx.fillText('A', A.x*0.95, A.y*1.05)
    ctx.fillText('P', P.x*0.95, P.y*0.95)
    //ctx.fillText('ZAB = '+((Math.PI-crank_angle)*180/Math.PI+wrapAngle(coupler_angle)*180/Math.PI).toFixed(2) + ' deg.', 300, 10);
    //ctx.fillText('BYZ = '+((Math.PI-wrapAngle(output_angle))*180/Math.PI).toFixed(2) + ' deg.', 300, 20);

    document.getElementById('theta3').innerText = (coupler_angle*180/Math.PI).toFixed(2);
    document.getElementById('theta4').innerText = (output_angle*180/Math.PI).toFixed(2);
    //ctx.fillText('YZA = '+(wrapAngle(crank_angle)*180/Math.PI).toFixed(2), Z.x*0.85, Z.y*0.85);

    crankAngleSlider.value=wrapAngle(crank_angle)*180/Math.PI;
    crankAngleSlider.oninput = () => updateDisplay(crankAngleSlider, 'crankAngleSlider');
    document.getElementById('crankAngleSlider').innerText = crankAngleSlider.value;

    let region = new Path2D();
    region.moveTo(A.x, A.y);
    region.lineTo(P.x, P.y);
    region.lineTo(B.x, B.y);
    region.closePath();

    // Fill path
    ctx.fillStyle = "rgba(0, 0, 0, 0.2)";
    ctx.fill(region, "evenodd");

}

function drawCrankSlider(){
    const cs_coupler = parseInt(cs_couplerSlider.value);
    const cs_crank = parseInt(cs_crankSlider.value);
    const cs_offset = parseInt(cs_offsetSlider.value);
    let cs_crank_angle = cs_crankAngleSlider.value*Math.PI/180; // Starting angle for the rotation

    cs_ctx.clearRect(0, 0, cs_canvas.width, cs_canvas.height);
    //drawCouplerCurve();

    // Fixed point (Z)
    const Z= { x: 100, y: 100 };

    // Calculate positions for the four-bar linkage
    let cfg=1;
    if (cs_configCheckbox.checked) {
        cfg=0;
    }
    const t3d=cs_position(cs_crank,cs_coupler,cs_offset,
        cs_crank_angle,cfg)
    const cs_coupler_angle = t3d[0];
    const d_cs = t3d[1];

    const A = {
        x: Z.x + cs_crank * Math.cos(cs_crank_angle),
        y: Z.y + cs_crank * Math.sin(cs_crank_angle)
    };

    const B = {
        x: A.x + cs_coupler * Math.cos(cs_coupler_angle-Math.PI),
        y: A.y + cs_coupler * Math.sin(cs_coupler_angle-Math.PI)
    };


    A.y=cs_canvas.height-A.y;
    B.y=cs_canvas.height-B.y;
    Z.y=cs_canvas.height-Z.y;


    // Draw the links
    // Draw the crank.
    cs_ctx.beginPath();
    cs_ctx.moveTo(Z.x, Z.y);
    cs_ctx.strokeStyle = '#FF0000';
    cs_ctx.lineTo(A.x, A.y);
    cs_ctx.stroke();

    // Draw the coupler.
    cs_ctx.beginPath();
    cs_ctx.moveTo(A.x, A.y);
    cs_ctx.strokeStyle = "#00FF00";
    cs_ctx.lineTo(B.x, B.y);
    cs_ctx.stroke();

    // Draw the second ground
    cs_ctx.beginPath();
    cs_ctx.setLineDash([1, 2]);
    cs_ctx.moveTo(Z.x-cs_crank-cs_coupler, B.y+10);
    cs_ctx.strokeStyle = "#000000";
    cs_ctx.lineTo(Z.x+cs_crank+cs_coupler, B.y+10);
    cs_ctx.stroke();
    cs_ctx.setLineDash([]); // Empty array sets a solid line

    // Draw the points
    drawGround(Z, "rgb(0,0,0,0.5", cs_ctx);
    drawGround(B, "rgb(0,0,255,0.5", cs_ctx);
    drawPinJoint(Z,cs_ctx);
    drawPinJoint(B, cs_ctx);
    drawPinJoint(A,cs_ctx);

        // show the points
    cs_ctx.fillText('Z', Z.x*0.95, Z.y*1.05)
    cs_ctx.fillText('B', B.x*1.05, B.y*0.95)
    cs_ctx.fillText('A', A.x*0.95, A.y*1.05)

    document.getElementById('theta3_cs').innerText = (cs_coupler_angle*180/Math.PI).toFixed(2);
    document.getElementById('d_cs').innerText = d_cs.toFixed(2);

}
function wrapAngle(angle) {
    return angle - 2 * Math.PI * Math.floor(angle / (2 * Math.PI));
  }
function drawPoint(point, color, ctx) {
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(point.x, point.y, 5, 0, Math.PI * 2);
    ctx.fill();
}

function drawPinJoint(point, ctx) {
    //ctx.fillStyle = "rgba(0,0,0,1)";
    ctx.beginPath();
    ctx.strokeStyle = 'black';
    ctx.arc(point.x, point.y, 3, 0, Math.PI * 2);
    ctx.stroke();
    //ctx.fill();
}

function drawGround(point, color, ctx){
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.rect(point.x-10, point.y-10, 20, 20);
    // ctx.stroke();
    ctx.fill()
}

function animate() {
    if (isPlaying) {
        crank_angle += 0.05; // Change the angle for rotation
        drawFourBar();
        requestAnimationFrame(animate); // Call animate again for the next frame
    }
}

// Initial draw
drawFourBar();
drawCrankSlider();

