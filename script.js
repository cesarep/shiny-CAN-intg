tabela = function(){
   document.querySelector('tbody').insertAdjacentHTML('beforeend', "<tr id='mais'><td class='mais' colspan=2></td></tr>");
   document.querySelectorAll('tr:nth-child(10) ~ tr:not(#mais)').forEach(i => i.classList.add('escondido'));
   document.querySelector('tr#mais').onclick = function(){
      document.querySelectorAll('tr:nth-child(10) ~ tr:not(#mais)').forEach(i => i.classList.toggle('escondido'));
      document.querySelector('tr#mais td').classList.toggle('menos');
   };
}

$(document).on("shiny:value", function(e) {
   if (e.name == "tabela") {  // mytable is the name / id of the output element
      e.preventDefault();
      $("#tabela").html(e.value);  // render the output from the server
      if(e.value.match(/<tr>/g || []).length > 12)
         tabela();
   }
});