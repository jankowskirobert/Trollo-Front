module.exports = (req, res, next) => {
    if (req.method === 'POST' && req.path === '/login') {
      if (req.body.username === 'user' && req.body.password === 'pass') {
        res.status(200).json({token: 'testowySuperTajnyToken'});
      } else { 
        res.status(400).json({message: 'wrong password'});
      }
    } else {
      next();
    }
  }