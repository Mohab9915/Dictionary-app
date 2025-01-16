function searchWordMatch() 
{ 

    var w = document.getElementById('search').value;

    if(!w)
    {
        document.getElementById('word').textContent = '';
        document.getElementById('def').textContent = 'Empty, enter a word.';
        return;
    }

    var form = new FormData();
    var x = new XMLHttpRequest();

    form.append('word', w);
    form.append('search', true);
    x.open('POST', 'index.php', true); 

    x.onload = function () {
        if (x.status === 200) 
            {
            var res_text = x.responseText;
            
            var temp = document.createElement('div');
            temp.innerHTML = res_text;
            
            var definition = temp.querySelector('.result');
            var error = temp.querySelector('.error');
            
            if (definition) 
            {
                document.getElementById('word').textContent = definition.querySelector('h3').textContent;
                document.getElementById('def').textContent = definition.querySelector('p').textContent;
            }
             else if (error) 
            {
                document.getElementById('word').textContent = '';
                document.getElementById('def').textContent = error.textContent; 
            }
            else
            {
                document.getElementById('word').textContent='';
                document.getElementById('def').textContent='Response unexpected.';
            }
        }
         else 
        {
            document.getElementById('word').textContent = '';
            document.getElementById('def').textContent = 'Error: '+ x.status;
        }
    };

    x.send(form);
}
