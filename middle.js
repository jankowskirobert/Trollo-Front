module.exports = (req, res, next) => {
  if (req.method === 'POST' && req.path === '/login') {
    if (req.body.username === 'user' && req.body.password === 'pass') {
      return res.status(200).json({
        token: 'testowySuperTajnyToken'
      });
    } else {
      return  res.status(400).json({
        message: 'wrong password'
      });
    }
  } else {
    next();
  }
  if (eq.method === 'GET' && req.path === '/boards/' && req.header('Authorization') != null ) {

    // user and password are stored in the authorization header
    // do whatever you want with them
    // var bearer = req.headers.authorization.split(" ")[0];
    var gg =req.header('Authorization');
    console.log(gg);
    // for example, get the username
    // var token = user_and_password.split(':')[1];


    // continue doing json-server magic
    next();

  } else {
    // console.log("gg.toString()");
    // next();
    // it is not recommended in REST APIs to throw errors,
    // instead, we send 401 response with whatever erros
    // we want to expose to the client
    return res.status(401).send({ error: 'Unauthorized' });
  }
};